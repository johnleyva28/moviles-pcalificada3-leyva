import SwiftUI

struct RegistroView: View {
    @EnvironmentObject private var session: SessionStore
    @StateObject private var viewModel = RegistroViewModel()

    let onBack: () -> Void
    let onRegistered: () -> Void

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
                            Text("CREA TU CUENTA")
                                .font(WDLFont.display(30, weight: .bold))
                                .tracking(2)
                                .foregroundStyle(.white)

                            Text("Regístrate para seguir con los Resultados")
                                .font(WDLFont.sans(12))
                                .tracking(1)
                                .foregroundStyle(Color.wdlLime)
                        }

                        VStack(spacing: 16) {
                            field(
                                title: "Nombre",
                                symbol: "person",
                                text: $viewModel.name,
                                isValid: nil
                            )

                            field(
                                title: "Correo electrónico",
                                symbol: "envelope",
                                isEmail: true,
                                text: $viewModel.email,
                                isValid: viewModel.email.isEmpty ? nil : viewModel.isEmailValid
                            )

                            field(
                                title: "Contraseña",
                                symbol: "lock",
                                isSecure: true,
                                text: $viewModel.password,
                                isValid: nil
                            )

                            field(
                                title: "Confirmar contraseña",
                                symbol: "lock.rotation",
                                isSecure: true,
                                text: $viewModel.confirmPassword,
                                isValid: viewModel.confirmPassword.isEmpty ? nil : viewModel.passwordsMatch
                            )

                            if let error = viewModel.errorMessage {
                                Label(error, systemImage: "exclamationmark.triangle.fill")
                                    .font(WDLFont.sans(13, weight: .medium))
                                    .foregroundStyle(Color.wdlError)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                            }

                            if viewModel.isRegistered {
                                Label("Cuenta creada", systemImage: "checkmark.seal.fill")
                                    .font(WDLFont.sans(14, weight: .semibold))
                                    .foregroundStyle(Color.wdlSuccess)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .transition(.opacity.combined(with: .move(edge: .top)))
                            }

                            Button {
                                if viewModel.register(using: session) {
                                    Task {
                                        try? await Task.sleep(for: .seconds(1))
                                        onRegistered()
                                    }
                                }
                            } label: {
                                Text("Crear cuenta")
                                    .font(WDLFont.sans(17, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(Color.wdlGreen, in: RoundedRectangle(cornerRadius: 12))
                            }
                            .disabled(!viewModel.canSubmit)
                            .opacity(viewModel.canSubmit ? 1 : 0.5)

                            Button(action: onBack) {
                                Text("¿Ya tienes cuenta? Inicia sesión")
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
        .animation(.easeInOut(duration: 0.25), value: viewModel.isRegistered)
    }

    private func field(
        title: String,
        symbol: String,
        isSecure: Bool = false,
        isEmail: Bool = false,
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
                    .textInputAutocapitalization(isEmail ? .never : .words)
                    .keyboardType(isEmail ? .emailAddress : .default)
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
    RegistroView(onBack: {}, onRegistered: {})
        .environmentObject(SessionStore())
}
