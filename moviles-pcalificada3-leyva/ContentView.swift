import SwiftUI

struct ContentView: View {
    // La navegación del Splash es un valor simple sin dependencias externas:
    // @State es suficiente (y más barato) que @StateObject.
    @State private var route: Route = .splash
    @EnvironmentObject private var session: SessionStore

    var body: some View {
        ZStack {
            if route == .splash {
                SplashView { route = .login }
                    .transition(.opacity)
            } else if route == .login {
                LoginView(
                    onRegister: { route = .registro },
                    onSuccess: { route = .home }
                )
                .transition(.opacity)
            } else if route == .registro {
                RegistroView(
                    onBack: { route = .login },
                    onRegistered: { route = .home }
                )
                .transition(.opacity)
            } else {
                HomeView(onLogout: {
                    session.logout()
                    route = .login
                })
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: route)
    }
}

enum Route: Equatable {
    case splash
    case login
    case registro
    case home
}

#Preview {
    ContentView()
        .environmentObject(SessionStore())
}
