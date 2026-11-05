import SwiftUI

struct SplashView: View {
    let onFinish: () -> Void

    @State private var appeared = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.wdlGreenHover, .wdlDeepGreen],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            Circle()
                .fill(Color.wdlLime.opacity(0.12))
                .frame(width: 340, height: 340)
                .blur(radius: 60)
                .offset(y: -80)

            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 148, height: 148)
                    TennisBall()
                        .frame(width: 108, height: 108)
                }
                .scaleEffect(appeared ? 1 : 0.6)
                .opacity(appeared ? 1 : 0)

                VStack(spacing: 8) {
                    Text("WIMBLEDON")
                        .font(WDLFont.display(46, weight: .bold))
                        .tracking(4)
                        .foregroundStyle(.white)

                    Text("THE CHAMPIONSHIPS")
                        .font(WDLFont.sans(13, weight: .medium))
                        .tracking(3.5)
                        .foregroundStyle(Color.wdlLime)
                }
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 24)
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

private struct TennisBall: View {
    var body: some View {
        Canvas { context, size in
            let radius = min(size.width, size.height) / 2
            let center = CGPoint(x: size.width / 2, y: size.height / 2)

            context.fill(
                Path(ellipseIn: CGRect(
                    x: center.x - radius, y: center.y - radius,
                    width: radius * 2, height: radius * 2
                )),
                with: .color(Color.wdlLimeSoft)
            )

            // Costura característica: dos arcos enfrentados ")("
            var seam = Path()
            seam.move(to: CGPoint(x: center.x - radius * 0.35, y: center.y - radius * 0.92))
            seam.addQuadCurve(
                to: CGPoint(x: center.x - radius * 0.35, y: center.y + radius * 0.92),
                control: CGPoint(x: center.x + radius * 0.6, y: center.y)
            )
            seam.move(to: CGPoint(x: center.x + radius * 0.35, y: center.y - radius * 0.92))
            seam.addQuadCurve(
                to: CGPoint(x: center.x + radius * 0.35, y: center.y + radius * 0.92),
                control: CGPoint(x: center.x - radius * 0.6, y: center.y)
            )
            context.stroke(seam, with: .color(.white), style: StrokeStyle(lineWidth: radius * 0.13, lineCap: .round))
        }
    }
}

#Preview {
    SplashView(onFinish: {})
}
