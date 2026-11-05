import Combine
import Foundation

@MainActor
final class RegistroViewModel: ObservableObject {
    @Published var name = "" { didSet { revalidate() } }
    @Published var email = "" { didSet { revalidate() } }
    @Published var password = "" { didSet { revalidate() } }
    @Published var confirmPassword = "" { didSet { revalidate() } }
    @Published private(set) var errorMessage: String?
    @Published private(set) var isRegistered = false

    private var hasAttempted = false

    var canSubmit: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
            && !email.trimmingCharacters(in: .whitespaces).isEmpty
            && !password.isEmpty
            && !confirmPassword.isEmpty
    }

    var isEmailValid: Bool { LoginViewModel.isValidEmail(email) }
    var passwordsMatch: Bool { password == confirmPassword }

    /// - Returns: `true` si la cuenta se creó y el usuario quedó autenticado.
    func register(using session: SessionStore) -> Bool {
        hasAttempted = true
        isRegistered = false
        revalidate()
        if errorMessage != nil { return false }

        if session.isEmailRegistered(email) {
            errorMessage = "Ya existe una cuenta con ese correo."
            return false
        }

        session.register(
            name: name.trimmingCharacters(in: .whitespaces),
            email: email.trimmingCharacters(in: .whitespaces),
            password: password
        )
        session.currentUser = session.registeredUsers.last
        isRegistered = true
        return true
    }

    /// El error se recalcula en cada cambio de campo, así desaparece solo al corregir.
    private func revalidate() {
        isRegistered = false
        errorMessage = hasAttempted ? Self.validate(
            name: name,
            email: email,
            password: password,
            confirmPassword: confirmPassword
        ) : nil
    }

    nonisolated static func validate(
        name: String,
        email: String,
        password: String,
        confirmPassword: String
    ) -> String? {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)

        if trimmedName.isEmpty { return "Ingresa tu nombre." }
        if trimmedEmail.isEmpty { return "Ingresa tu correo electrónico." }
        if !LoginViewModel.isValidEmail(trimmedEmail) { return "El correo electrónico no tiene un formato válido." }
        if password.isEmpty { return "Ingresa tu contraseña." }
        if confirmPassword.isEmpty { return "Confirma tu contraseña." }
        if password != confirmPassword { return "Las contraseñas no coinciden." }
        // Se reutiliza la misma regla del Login para que toda cuenta creada
        // pueda luego autenticarse.
        if let passwordError = LoginViewModel.validate(email: trimmedEmail, password: password) {
            return passwordError
        }
        return nil
    }
}
