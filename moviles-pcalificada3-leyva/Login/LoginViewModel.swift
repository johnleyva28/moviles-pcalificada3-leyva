import Combine
import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email = "" { didSet { revalidate() } }
    @Published var password = "" { didSet { revalidate() } }
    @Published private(set) var errorMessage: String?

    private var hasAttemptedLogin = false

    /// El botón solo se deshabilita con campos vacíos (rúbrica); con datos inválidos
    /// se muestra el mensaje de error al pulsar.
    var canSubmit: Bool {
        !email.trimmingCharacters(in: .whitespaces).isEmpty && !password.isEmpty
    }

    var isEmailValid: Bool { Self.isValidEmail(email) }
    var isPasswordValid: Bool { Self.isValidPassword(password) }

    /// - Returns: `true` si los datos son válidos y la sesión quedó guardada.
    func login(using session: SessionStore) -> Bool {
        hasAttemptedLogin = true
        revalidate()
        guard errorMessage == nil else { return false }

        session.authenticate(email: email, password: password)
        return true
    }

    /// El error se recalcula en cada cambio de campo, así desaparece solo al corregir.
    private func revalidate() {
        errorMessage = hasAttemptedLogin ? Self.validate(email: email, password: password) : nil
    }

    nonisolated static func validate(email: String, password: String) -> String? {
        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)

        if trimmedEmail.isEmpty { return "Ingresa tu correo electrónico." }
        if !isValidEmail(trimmedEmail) { return "El correo electrónico no tiene un formato válido." }
        if password.isEmpty { return "Ingresa tu contraseña." }
        if password.count < 6 { return "La contraseña debe tener al menos 6 caracteres." }
        if !password.contains(where: { $0.isUppercase }) { return "La contraseña debe tener al menos una mayúscula." }
        if !containsValidSpecialCharacter(password) {
            return "La contraseña debe tener al menos un carácter especial (no puede ser punto, coma ni tilde)."
        }
        return nil
    }

    nonisolated static func isValidEmail(_ email: String) -> Bool {
        let pattern = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }

    nonisolated static func isValidPassword(_ password: String) -> Bool {
        password.count >= 6
            && password.contains(where: { $0.isUppercase })
            && containsValidSpecialCharacter(password)
    }

    /// Carácter especial = puntuación ASCII que no sea punto, coma ni punto y coma.
    /// Las tildes y la ñ quedan excluidas porque no son ASCII.
    nonisolated static func containsValidSpecialCharacter(_ password: String) -> Bool {
        let forbidden: Set<Character> = [".", ",", ";"]
        return password.contains { character in
            guard let ascii = character.asciiValue else { return false }
            let isPunctuation = ascii < 128
                && !character.isLetter
                && !character.isNumber
                && !character.isWhitespace
            return isPunctuation && !forbidden.contains(character)
        }
    }
}
