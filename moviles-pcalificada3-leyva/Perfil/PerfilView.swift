import SwiftUI

struct PerfilView: View {
    @EnvironmentObject private var session: SessionStore

    let onLogout: () -> Void

    var body: some View {
        NavigationStack {
            ZStack {
                Color.wdlPurpleSoft.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 18) {
                        card

                        Button(action: onLogout) {
                            HStack(spacing: 10) {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                Text("Cerrar sesión")
                            }
                            .font(WDLFont.sans(16, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(Color.wdlPurple, in: RoundedRectangle(cornerRadius: 12))
                        }

                        Text("Wimbledon · The Championships")
                            .font(WDLFont.sans(12))
                            .foregroundStyle(Color.wdlInkSecondary)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Perfil")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var card: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color.wdlPurple)
                Image(systemName: "person.fill")
                    .font(.system(size: 42, weight: .semibold))
                    .foregroundStyle(Color.wdlMint)
            }
            .frame(width: 92, height: 92)

            Text(session.currentUser?.name ?? "Usuario")
                .font(WDLFont.display(24, weight: .bold))
                .foregroundStyle(Color.wdlDeepPurple)

            Text(session.currentUser?.email ?? "sin correo")
                .font(WDLFont.sans(14))
                .foregroundStyle(Color.wdlInkSecondary)

            HStack(spacing: 0) {
                stat(value: "\(session.registeredUsers.count)", label: "Cuentas")
                Divider().frame(height: 34).overlay(Color.wdlBorder)
                stat(value: "\(HomeViewModel.sampleItems.count)", label: "Jugadores")
                Divider().frame(height: 34).overlay(Color.wdlBorder)
                stat(value: "128", label: "En cuadro")
            }
            .padding(.top, 6)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(.white, in: RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color.wdlBorder, lineWidth: 1)
        }
    }

    private func stat(value: String, label: String) -> some View {
        VStack(spacing: 3) {
            Text(value)
                .font(WDLFont.display(20, weight: .bold))
                .foregroundStyle(Color.wdlPurple)
            Text(label)
                .font(WDLFont.sans(11))
                .foregroundStyle(Color.wdlInkSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    PerfilView(onLogout: {})
        .environmentObject(SessionStore())
}
