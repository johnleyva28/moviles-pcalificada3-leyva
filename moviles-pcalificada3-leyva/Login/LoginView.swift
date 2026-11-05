import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var session: SessionStore
    @StateObject private var viewModel = LoginViewModel()

    let onRegister: () -> Void
    let onSuccess: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.wdlGreenHover, .wdlDeepGreen],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            GeometryReader { proxy in
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            Text("WIMBLEDON")
                                .font(WDLFont.display(34, weight: .bold))
                                .tracking(3)
                                .foregroundStyle(.white)

                            Text("THE CHAMPIONSHIPS")
                                .font(WDLFont.sans(11, weight: .medium))
                                .tracking(3)
                                .foregroundStyle(Color.wdlLime)
                        }

                        VStack(spacing: 16) {
                            field(
                                title: "Correo electrónico",
                                symbol: "envelope",
                                text: $viewModel.email,
                                isValid: viewModel.email.isEmpty ? nil : viewModel.isEmailValid
                            )

                            field(
                                title: "Contraseña",
                                symbol: "lock",
                                isSecure: true,
                                text: $viewModel.password,
                                isValid: viewModel.password.isEmpty ? nil : viewModel.isPasswordValid
                            )

                            if let error = viewModel.errorMessage {
                                Label(error, systemImage: "exclamationmark.triangle.fill")
                                    .font(WDLFont.sans(13, weight: .medium))
                                    .foregroundStyle(Color.wdlError)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                            }

                            Button {
                                if viewModel.login(using: session) {
                                    onSuccess()
                                }
                            } label: {
                                Text("Iniciar sesión")
                                    .font(WDLFont.sans(17, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(Color.wdlGreen, in: RoundedRectangle(cornerRadius: 12))
                            }
                            .disabled(!viewModel.canSubmit)
                            .opacity(viewModel.canSubmit ? 1 : 0.5)

                            Button(action: onRegister) {
                                Text("¿No tienes cuenta? Regístrate")
                                    .font(WDLFont.sans(14, weight: .medium))
                                    .foregroundStyle(Color.wdlGreen)
                            }
                        }
                        .padding(20)
                        .background(.white, in: RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .black.opacity(0.12), radius: 12, y: 4)
                    }
                    .padding(.horizontal, 28)
                    .frame(minHeight: proxy.size.height)
                    .frame(maxWidth: .infinity)
                }
                .scrollDismissesKeyboard(.interactively)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: viewModel.errorMessage)
    }

    private func field(
        title: String,
        symbol: String,
        isSecure: Bool = false,
        text: Binding<String>,
        isValid: Bool?
    ) -> some View {
        HStack(spacing: 12) {
            Image(systemName: symbol)
                .foregroundStyle(Color.wdlInkSecondary)

            if isSecure {
                SecureField(title, text: text)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            } else {
                TextField(title, text: text)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
            }

            if let isValid {
                Image(systemName: isValid ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundStyle(isValid ? Color.wdlSuccess : Color.wdlError)
                    .transition(.opacity)
            }
        }
        .padding(14)
        .background(Color.wdlSurface, in: RoundedRectangle(cornerRadius: 10))
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(strokeColor(isValid), lineWidth: 1.5)
        }
        .animation(.easeInOut(duration: 0.2), value: isValid)
    }

    private func strokeColor(_ isValid: Bool?) -> Color {
        guard let isValid else { return .clear }
        return isValid ? Color.wdlSuccess : Color.wdlError
    }
}

#Preview {
    LoginView(onRegister: {}, onSuccess: {})
        .environmentObject(SessionStore())
}
