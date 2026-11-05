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

    /// Valida el formato (lo hace el ViewModel) y guarda la sesión en memoria.
    /// Si el correo corresponde a una cuenta registrada se usa ese usuario;
    /// si no, se crea una sesión temporal con los datos ingresados.
    func authenticate(email: String, password: String) {
        if let match = registeredUsers.first(where: { $0.email.lowercased() == email.lowercased() }) {
            currentUser = match
        } else {
            currentUser = User(name: Self.name(from: email), email: email, password: password)
        }
    }

    func logout() {
        currentUser = nil
    }

    private static func name(from email: String) -> String {
        String(email.split(separator: "@").first ?? "Usuario")
    }
}
