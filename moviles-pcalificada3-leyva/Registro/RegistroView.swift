import SwiftUI

// Placeholder del paso 3 (formulario de registro con unicidad de email).
struct RegistroView: View {
    @EnvironmentObject private var session: SessionStore

    let onBack: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.wdlGreenHover, .wdlDeepGreen],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Regístrate")
                    .font(WDLFont.display(30, weight: .bold))
                    .foregroundStyle(.white)

                Text("Disponible en el paso 3 de la evaluación")
                    .font(WDLFont.sans(14))
                    .foregroundStyle(Color.wdlLime)

                Button("Volver", action: onBack)
                    .font(WDLFont.sans(16, weight: .semibold))
                    .foregroundStyle(Color.wdlGreen)
            }
        }
    }
}

#Preview {
    RegistroView(onBack: {})
        .environmentObject(SessionStore())
}
