import SwiftUI

struct SplashView: View {
    let onFinish: () -> Void

    @State private var appeared = false

    var body: some View {
        ZStack {
            // Verde profundo plano, como la portada del programa oficial.
            Color.wdlDeepGreen.ignoresSafeArea()

            VStack(spacing: WDLSpace.l) {
                ZStack {
                    Circle()
                        .fill(Color.wdlPaper)

                    Image("LogoWimbledon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 176, height: 176)
                }
                .frame(width: 190, height: 190)
                .scaleEffect(appeared ? 1 : 0.6)
                .opacity(appeared ? 1 : 0)

                VStack(spacing: WDLSpace.xs) {
                    // Nombre de la app con fuente personalizada (requisito del criterio).
                    Text("WIMBLEDON")
                        .font(WDLFont.display(40, weight: .bold))
                        .tracking(5)
                        .foregroundStyle(Color.wdlPaper)

                    Rectangle()
                        .fill(Color.wdlLime)
                        .frame(width: 44, height: 2)

                    Text("THE CHAMPIONSHIPS")
                        .font(WDLType.caption)
                        .tracking(3)
                        .foregroundStyle(Color.wdlLime)
                }
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 20)
            }
            .padding(.horizontal, WDLSpace.xl)
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
