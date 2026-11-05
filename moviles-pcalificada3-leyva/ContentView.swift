import SwiftUI

struct ContentView: View {
    // La navegación del Splash es un valor simple sin dependencias externas:
    // @State es suficiente (y más barato) que @StateObject.
    @State private var route: Route = .splash

    var body: some View {
        switch route {
        case .splash:
            SplashView { route = .login }
                .transition(.opacity)
        case .login:
            LoginView()
                .transition(.opacity)
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
