import SwiftUI

struct SplashView: View {
    let onFinish: () -> Void

    @State private var appeared = false

    var body: some View {
        ZStack {
            // Verde de cancha y morado del escudo: los dos colores de marca.
            LinearGradient(
                colors: [.wdlCourt, .wdlDeepPurple],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            Circle()
                .fill(Color.wdlLime.opacity(0.10))
                .frame(width: 320, height: 320)
                .blur(radius: 60)
                .offset(y: -110)

            VStack(spacing: 26) {
                ZStack {
                    // Disco blanco: el escudo es morado y necesita contraste.
                    Circle()
                        .fill(.white)

                    Image("LogoWimbledon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 176, height: 176)
                }
                .frame(width: 190, height: 190)
                .scaleEffect(appeared ? 1 : 0.6)
                .opacity(appeared ? 1 : 0)

                Text("THE CHAMPIONSHIPS")
                    .font(WDLFont.sans(12, weight: .medium))
                    .tracking(3.5)
                    .foregroundStyle(Color.wdlLime)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.7)) {
                appeared = true
            }
        }
        .task {
            try? await Task.sleep(for: .seconds(2))
            onFinish()
        }
    }
}

#Preview {
    SplashView(onFinish: {})
}
