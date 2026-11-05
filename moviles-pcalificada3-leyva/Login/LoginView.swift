import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var session: SessionStore
    @StateObject private var viewModel = LoginViewModel()

    @State private var showsPassword = false
    @State private var toast: Toast?

    let onRegister: () -> Void
    let onSuccess: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.wdlCourt, .wdlDeepPurple],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            GeometryReader { proxy in
                ScrollView {
                    VStack(spacing: WDLSpace.xl) {
                        VStack(spacing: WDLSpace.xs) {
                            Text("WIMBLEDON")
                                .font(WDLFont.display(28, weight: .bold))
                                .tracking(3)
                                .foregroundStyle(Color.wdlPaper)

                            Rectangle()
                                .fill(Color.wdlLime)
                                .frame(width: 36, height: 2)

                            Text("THE CHAMPIONSHIPS")
                                .font(WDLType.caption)
                                .tracking(3)
                                .foregroundStyle(Color.wdlLime)
                        }

                        VStack(spacing: WDLSpace.m) {
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
                                isValid: viewModel.password.isEmpty ? nil : viewModel.isPasswordValid,
                                reveal: $showsPassword
                            )

                            Button {
                                if viewModel.login(using: session) {
                                    onSuccess()
                                } else if let error = viewModel.errorMessage {
                                    show(Toast(message: error, kind: .error))
                                }
                            } label: {
                                Text("Iniciar sesión")
                                    .font(WDLType.subhead)
                                    .foregroundStyle(Color.wdlPaper)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, WDLSpace.m)
                                    .background(Color.wdlGreen, in: RoundedRectangle(cornerRadius: WDLRadius.control))
                            }
                            .disabled(!viewModel.canSubmit)
                            .opacity(viewModel.canSubmit ? 1 : 0.45)

                            Button(action: onRegister) {
                                Text("¿No tienes cuenta? Regístrate")
                                    .font(WDLType.footnote)
                                    .foregroundStyle(Color.wdlGreen)
                            }
                        }
                        .padding(WDLSpace.l)
                        .background(Color.wdlPaper, in: RoundedRectangle(cornerRadius: WDLRadius.container))
                        .overlay {
                            RoundedRectangle(cornerRadius: WDLRadius.container)
                                .strokeBorder(Color.wdlBorder, lineWidth: 1)
                        }
                    }
                    .padding(.horizontal, WDLSpace.l)
                    .frame(minHeight: proxy.size.height)
                    .frame(maxWidth: .infinity)
                }
                .scrollDismissesKeyboard(.interactively)
            }
        }
        .toast(toast)
        .animation(.easeInOut(duration: 0.25), value: viewModel.errorMessage)
    }

    /// Muestra el toast y lo descarta solo a los 3 segundos.
    private func show(_ newToast: Toast) {
        toast = newToast
        Task {
            try? await Task.sleep(for: .seconds(3))
            withAnimation { toast = nil }
        }
    }

    private func field(
        title: String,
        symbol: String,
        isSecure: Bool = false,
        text: Binding<String>,
        isValid: Bool?,
        reveal: Binding<Bool>? = nil
    ) -> some View {
        HStack(spacing: WDLSpace.m) {
            Image(systemName: symbol)
                .foregroundStyle(Color.wdlInkSecondary)

            if isSecure {
                Group {
                    if reveal?.wrappedValue == true {
                        TextField(title, text: text)
                    } else {
                        SecureField(title, text: text)
                    }
                }
                .font(WDLType.body)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                // Evita el panel amarillo de "contraseña sugerida" del simulador.
                .textContentType(.password)
            } else {
                TextField(title, text: text)
                    .font(WDLType.body)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textContentType(.emailAddress)
            }

            if let reveal {
                Button {
                    reveal.wrappedValue.toggle()
                } label: {
                    Image(systemName: reveal.wrappedValue ? "eye.slash" : "eye")
                        .foregroundStyle(Color.wdlInkSecondary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(reveal.wrappedValue ? "Ocultar contraseña" : "Mostrar contraseña")
            }

            if let isValid {
                Image(systemName: isValid ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundStyle(isValid ? Color.wdlSuccess : Color.wdlError)
                    .transition(.opacity)
            }
        }
        .padding(.horizontal, WDLSpace.m)
        .padding(.vertical, WDLSpace.m)
        .background(Color.wdlSurface, in: RoundedRectangle(cornerRadius: WDLRadius.control))
        .overlay {
            RoundedRectangle(cornerRadius: WDLRadius.control)
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
