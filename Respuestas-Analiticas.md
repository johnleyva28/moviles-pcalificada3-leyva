# Respuestas analíticas — Evaluación 03 (App Wimbledon)

---

## 1. Splash — ¿Por qué usar `@State` y no `@StateObject` para controlar la navegación?

Porque la navegación del Splash es un dato simple, un `enum Route` con los valores `.splash`, `.login`, `.registro` y `.home`. No es un objeto que otros observen ni que emita cambios, así que no necesita ser una clase.

`@StateObject` existe para objetos de referencia `ObservableObject`: SwiftUI los crea una sola vez y los conserva aunque la vista se redibuje. `@State` guarda el valor directamente en el estado de la vista, sin crear ninguna instancia.

Poner un `enum` dentro de una clase `ObservableObject` solo para guardarlo sería indirectionismo: un `@Published` de más, un objeto de más en memoria y la necesidad de inyectarlo con `.environmentObject()`. `@State` es más barato y hace exactamente lo mismo.

Lo usaría como `@StateObject` si el Splash emitiera eventos que otras vistas necesitan escuchar, por ejemplo un `SplashViewModel` con `@Published var isReady` para que el Login se entere de que la animación ya terminó.

---

## 2. Login — ¿Qué diferencia hay entre bindear `viewModel.email` con `$` y pasar una copia del valor?

`$viewModel.email` entrega un `Binding<String>`, que mantiene el enlace de dos vías. Cuando el usuario escribe, el valor se guarda en el `email` del ViewModel, se dispara `objectWillChange` y la vista se redibuja. Si el ViewModel cambia el valor por código, el `TextField` también se actualiza.

Si en su lugar paso `viewModel.email` (una `String` copiada), el `TextField` queda atado a un `Binding.constant`. Lo que escribe el usuario se queda en el control y nunca llega al ViewModel. Entonces la validación miraría el valor viejo, el botón nunca se habilitaría y el `errorMessage` no podría aparecer.

La razón técnica: `String` es un tipo de valor. Un `Binding` es el puente que traduce entre las mutaciones de la vista y el estado del modelo. La copia rompe ese puente porque no conserva la identidad de la variable. Solo sirve cuando la vista solo lee y el valor nunca se reescribe, que es el caso contrario a un formulario validado.

---

## 3. Registro — ¿Por qué conviene usar `@EnvironmentObject` para el usuario autenticado en lugar de pasar el objeto por cada vista?

Porque `@EnvironmentObject` inyecta el `SessionStore` en el entorno de SwiftUI y cualquier vista lo lee con `@EnvironmentObject private var session: SessionStore`. El objeto se inyecta una sola vez en la `App` con `.environmentObject(session)` y todas las vistas lo obtienen gratis, sin importar la profundidad.

Si paso el `User` como parámetro, cada vista que lo necesite lo declara en su firma y cada vista que lo pase lo declara en la de la anterior. La dependencia se propaga como una cadena y agregar una vista obliga a tocar todas las anteriores. Además, como `SessionStore` es un `ObservableObject`, cuando `currentUser` cambia todas las vistas que lo leen se redibujan solas; con un parámetro tendría que sincronizar el estado a mano.

El costo es que la dependencia queda oculta en vez de visible en la firma, por eso conviene inyectarlo siempre en la `App` y nunca en una vista hija.

---

## 4. Home — Si el array filtrado se calcula en la Vista con `.filter` en el body, ¿qué problema de rendimiento surge y cómo lo resuelve el ViewModel?

El `.filter` en el body se ejecuta en cada redibujado de la vista, no solo cuando cambia el texto de búsqueda. El body de SwiftUI se re-evalúa por cualquier motivo que invalide la vista: otro `@State` que cambia, una notificación del sistema, un redibujado del padre. Cada vez se recorre el array completo con `O(n)` comparaciones y se crea un array nuevo.

La solución es mover el filtrado al `HomeViewModel`. Guardé `items` y `searchText` como `@Published` y calculo `filteredItems` una sola vez por cambio del texto, dentro de un `didSet`. La vista solo lee `viewModel.filteredItems`, que ya está listo, así que el coste se paga una vez y no en cada redibujado. Como `filteredItems` es un `@Published` propio, SwiftUI sabe exactamente qué cambió y redibuja solo lo necesario.

El beneficio extra es de testabilidad: la lógica de filtrado queda en un tipo comprobable sin levantar la UI.

---

## 5. Detalle — ¿Por qué es mejor que el detalle reciba un `ItemModel` por valor y no una referencia (`@ObservedObject`)?

Porque `ItemModel` es un `struct`, así que el detalle recibe una copia independiente. Es inmutable desde su punto de vista, nadie más puede modificarla y no depende de ningún contexto externo. Encaja con la idea de SwiftUI de que la vista es una función pura del estado: la fuente de verdad es el `HomeViewModel` y el detalle solo la proyecta.

Con `@ObservedObject` el detalle recibiría una referencia a un objeto observable, y todo lo que SwiftUI puede observar de esa referencia se vuelve una dependencia del redibujado: cualquier `@Published` que cambie redibuja el detalle aunque no haya cambiado nada de lo que el detalle muestra. Eso ata la vista a un objeto mutable y compartido.

Cambiaría la decisión cuando el elemento sea una entidad viva que puede mutar mientras se muestra, por ejemplo un chat que recibe mensajes o un carrito de compra cuyo total cambia. Ahí sí conviene observar el objeto para reflejar los cambios en vivo. Es el mismo criterio de la clase pasada: `ContactoEntity` es una clase de Core Data porque necesita ser mutable y persistida, mientras que `ItemModel` solo describe cómo se ve una entrada.
