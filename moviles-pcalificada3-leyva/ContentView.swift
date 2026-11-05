import SwiftUI

struct ContentView: View {
    // La navegación del Splash es un valor simple sin dependencias externas:
    // @State es suficiente (y más barato) que @StateObject.
    @State private var route: Route = .splash

    var body: some View {
        ZStack {
            if route == .splash {
                SplashView { route = .login }
                    .transition(.opacity)
            } else {
                LoginView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: route)
    }
}

enum Route: Equatable {
    case splash
    case login
}

#Preview {
    ContentView()
}
