import SwiftUI

struct SplashView: View {
    let onFinish: () -> Void

    @State private var appeared = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.wdlPurple, .wdlDeepPurple],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            Circle()
                .fill(Color.wdlPurple.opacity(0.35))
                .frame(width: 340, height: 340)
                .blur(radius: 60)
                .offset(y: -80)

            VStack(spacing: 28) {
                Image("LogoWimbledon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 190, height: 190)
                    .scaleEffect(appeared ? 1 : 0.6)
                    .opacity(appeared ? 1 : 0)

                Text("THE CHAMPIONSHIPS")
                    .font(WDLFont.sans(12, weight: .medium))
                    .tracking(3.5)
                    .foregroundStyle(.white.opacity(0.85))
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
