import SwiftUI

// Placeholder del paso 4 (listado con búsqueda y logout).
struct HomeView: View {
    @EnvironmentObject private var session: SessionStore

    let onLogout: () -> Void

    var body: some View {
        ZStack {
            Color.wdlSurface.ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Home")
                    .font(WDLFont.display(30, weight: .bold))
                    .foregroundStyle(Color.wdlGreen)

                Text(session.currentUser.map { "Sesión de \($0.email)" } ?? "Sin sesión")
                    .font(WDLFont.sans(14))
                    .foregroundStyle(Color.wdlInkSecondary)

                Text("Disponible en el paso 4 de la evaluación")
                    .font(WDLFont.sans(13))
                    .foregroundStyle(Color.wdlInkSecondary)

                Button("Cerrar sesión", action: onLogout)
                    .font(WDLFont.sans(16, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.vertical, 14)
                    .padding(.horizontal, 28)
                    .background(Color.wdlGreen, in: RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}

#Preview {
    HomeView(onLogout: {})
        .environmentObject(SessionStore())
}
