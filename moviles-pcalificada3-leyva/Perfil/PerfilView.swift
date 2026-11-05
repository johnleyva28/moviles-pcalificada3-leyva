import SwiftUI

struct PerfilView: View {
    @EnvironmentObject private var session: SessionStore

    let onLogout: () -> Void

    var body: some View {
        NavigationStack {
            ZStack {
                Color.wdlMint.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: WDLSpace.l) {
                        card

                        Button(action: onLogout) {
                            HStack(spacing: WDLSpace.s) {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                Text("Cerrar sesión")
                            }
                            .font(WDLType.subhead)
                            .foregroundStyle(Color.wdlPaper)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, WDLSpace.m)
                            .background(Color.wdlGreen, in: RoundedRectangle(cornerRadius: WDLRadius.control))
                        }

                        Text("Wimbledon · The Championships")
                            .font(WDLType.caption)
                            .foregroundStyle(Color.wdlInkSecondary)
                    }
                    .padding(WDLSpace.l)
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Perfil")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var card: some View {
        VStack(spacing: WDLSpace.m) {
            ZStack {
                Circle()
                    .fill(Color.wdlGrass)
                Image(systemName: "person.fill")
                    .font(.system(size: 38, weight: .semibold))
                    .foregroundStyle(Color.wdlMint)
            }
            .frame(width: 84, height: 84)

            VStack(spacing: 2) {
                Text(session.currentUser?.name ?? "Usuario")
                    .font(WDLType.title)
                    .foregroundStyle(Color.wdlDeepPurple)

                Text(session.currentUser?.email ?? "sin correo")
                    .font(WDLType.body)
                    .foregroundStyle(Color.wdlInkSecondary)
            }

            HStack(spacing: 0) {
                stat(value: "\(session.registeredUsers.count)", label: "Cuentas")
                divider
                stat(value: "\(HomeViewModel.sampleItems.count)", label: "Jugadores")
                divider
                stat(value: "128", label: "En cuadro")
            }
            .padding(.top, WDLSpace.s)
        }
        .frame(maxWidth: .infinity)
        .padding(WDLSpace.l)
        .background(Color.wdlPaper, in: RoundedRectangle(cornerRadius: WDLRadius.container))
        .overlay {
            RoundedRectangle(cornerRadius: WDLRadius.container)
                .strokeBorder(Color.wdlBorder, lineWidth: 1)
        }
    }

    private var divider: some View {
        Rectangle()
            .fill(Color.wdlHairline)
            .frame(width: 1, height: 30)
    }

    private func stat(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(WDLFont.display(17, weight: .bold))
                .monospacedDigit()
                .foregroundStyle(Color.wdlGreen)

            Text(label)
                .font(WDLType.caption)
                .foregroundStyle(Color.wdlInkSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    PerfilView(onLogout: {})
        .environmentObject(SessionStore())
}
