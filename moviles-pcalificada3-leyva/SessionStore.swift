import Combine
import Foundation

struct User: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var email: String
    var password: String
}

/// Estado global de sesión y registro. Se inyecta con `@EnvironmentObject`.
@MainActor
final class SessionStore: ObservableObject {
    @Published private(set) var registeredUsers: [User] = []
    @Published var currentUser: User?

    func isEmailRegistered(_ email: String) -> Bool {
        registeredUsers.contains { $0.email.lowercased() == email.lowercased() }
    }

    func register(name: String, email: String, password: String) {
        registeredUsers.append(User(name: name, email: email, password: password))
    }

    /// - Returns: mensaje de error, o `nil` si la autenticación fue exitosa.
    func authenticate(email: String, password: String) -> String? {
        guard !registeredUsers.isEmpty else {
            // Aún no hay cuentas creadas: el login solo valida formato (parte 2 de la evaluación).
            currentUser = User(name: Self.name(from: email), email: email, password: password)
            return nil
        }
        guard let match = registeredUsers.first(where: { $0.email.lowercased() == email.lowercased() }) else {
            return "No existe una cuenta con ese correo."
        }
        guard match.password == password else {
            return "La contraseña es incorrecta."
        }
        currentUser = match
        return nil
    }

    func logout() {
        currentUser = nil
    }

    private static func name(from email: String) -> String {
        String(email.split(separator: "@").first ?? "Usuario")
    }
}
