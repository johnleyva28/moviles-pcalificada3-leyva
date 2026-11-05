import SwiftUI

// Placeholder del paso 2 (validación en LoginViewModel).
struct LoginView: View {
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.wdlGreenHover, .wdlDeepGreen],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 28) {
                Text("WIMBLEDON")
                    .font(WDLFont.display(34, weight: .bold))
                    .tracking(3)
                    .foregroundStyle(.white)

                VStack(spacing: 16) {
                    field("Correo electrónico", text: $email, symbol: "envelope")
                    field("Contraseña", text: $password, symbol: "lock")
                }
                .padding(20)
                .background(.white, in: RoundedRectangle(cornerRadius: 16))

                Button("Iniciar sesión") {}
                    .font(WDLFont.sans(17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.wdlGreen, in: RoundedRectangle(cornerRadius: 12))
                    .disabled(email.isEmpty || password.isEmpty)
                    .opacity(email.isEmpty || password.isEmpty ? 0.5 : 1)
            }
            .padding(28)
        }
    }

    private func field(_ title: String, text: Binding<String>, symbol: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: symbol)
                .foregroundStyle(.wdlInkSecondary)
            TextField(title, text: text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
        }
        .padding(14)
        .background(Color.wdlSurface, in: RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    LoginView()
}
