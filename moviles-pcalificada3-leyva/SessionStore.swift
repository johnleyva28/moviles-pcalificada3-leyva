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

    /// Cambia el nombre visible del usuario autenticado (el correo no se modifica:
    /// es el identificador con el que inicia sesión).
    func updateName(_ name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }

        if var user = currentUser {
            user.name = trimmed
            currentUser = user
        }

        if let index = registeredUsers.firstIndex(where: { $0.id == currentUser?.id }) {
            registeredUsers[index].name = trimmed
        }
    }

    private static func name(from email: String) -> String {
        String(email.split(separator: "@").first ?? "Usuario")
    }
}
