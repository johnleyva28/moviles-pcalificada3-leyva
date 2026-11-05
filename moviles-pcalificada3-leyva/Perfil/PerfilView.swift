import SwiftUI

struct PerfilView: View {
    @EnvironmentObject private var session: SessionStore

    @State private var isEditingName = false
    @State private var draftName = ""

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
                    .fill(Color.wdlMint)
                Image(systemName: "person.fill")
                    .font(.system(size: 34, weight: .medium))
                    .foregroundStyle(Color.wdlPurple)
            }
            .frame(width: 84, height: 84)

            if isEditingName {
                nameEditor
            } else {
                nameDisplay
            }

            Text(session.currentUser?.email ?? "sin correo")
                .font(WDLType.footnote)
                .foregroundStyle(Color.wdlInkSecondary)

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

    private var nameDisplay: some View {
        HStack(spacing: WDLSpace.s) {
            Text(session.currentUser?.name ?? "Usuario")
                .font(WDLType.title)
                .foregroundStyle(Color.wdlDeepPurple)

            Button {
                draftName = session.currentUser?.name ?? ""
                isEditingName = true
            } label: {
                Image(systemName: "pencil")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.wdlGreen)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Cambiar nombre")
        }
    }

    private var nameEditor: some View {
        VStack(spacing: WDLSpace.s) {
            TextField("Tu nombre", text: $draftName)
                .font(WDLType.subhead)
                .textInputAutocapitalization(.words)
                .multilineTextAlignment(.center)
                .padding(.vertical, WDLSpace.s)
                .padding(.horizontal, WDLSpace.m)
                .background(Color.wdlSurface, in: RoundedRectangle(cornerRadius: WDLRadius.control))
                .overlay {
                    RoundedRectangle(cornerRadius: WDLRadius.control)
                        .strokeBorder(Color.wdlGreen, lineWidth: 1.5)
                }

            HStack(spacing: WDLSpace.m) {
                Button("Cancelar") {
                    isEditingName = false
                }
                .font(WDLType.footnote)
                .foregroundStyle(Color.wdlInkSecondary)

                Button("Guardar") {
                    session.updateName(draftName)
                    isEditingName = false
                }
                .font(WDLType.footnote)
                .foregroundStyle(Color.wdlGreen)
            }
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
