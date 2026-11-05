import SwiftUI

struct DetalleView: View {
    let item: ItemModel

    var body: some View {
        ZStack {
            Color.wdlMint.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    hero

                    VStack(alignment: .leading, spacing: WDLSpace.l) {
                        VStack(alignment: .leading, spacing: WDLSpace.xs) {
                            Text(item.name)
                                .font(WDLType.title)
                                .foregroundStyle(Color.wdlDeepPurple)

                            Text(item.subtitle)
                                .font(WDLType.body)
                                .foregroundStyle(Color.wdlInkSecondary)
                        }

                        attributes
                    }
                    .padding(WDLSpace.l)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.wdlPaper)
                }
            }
        }
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var hero: some View {
        ZStack(alignment: .bottomLeading) {
            Image(item.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 260)
                .clipped()

            LinearGradient(
                colors: [.clear, Color.wdlDeepGreen.opacity(0.85)],
                startPoint: .center,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 2) {
                Text("RANKING ATP")
                    .font(WDLType.caption)
                    .tracking(2)
                    .foregroundStyle(Color.wdlLime)

                Text("#\(item.ranking)")
                    .font(WDLFont.display(28, weight: .bold))
                    .monospacedDigit()
                    .foregroundStyle(Color.wdlPaper)
            }
            .padding(WDLSpace.l)
        }
        .frame(height: 260)
        .frame(maxWidth: .infinity)
        .clipped()
    }

    /// Lista de definición: etiqueta en versalitas, valor en serif.
    private var attributes: some View {
        VStack(spacing: 0) {
            attributeRow(title: "Títulos Grand Slam", value: "\(item.grandSlamTitles)")
            attributeRow(title: "País", value: item.country)
            attributeRow(title: "Altura", value: "\(item.height) cm")
            attributeRow(title: "Mano dominante", value: item.plays)
            attributeRow(title: "Superficie", value: item.surface)
        }
    }

    private func attributeRow(title: String, value: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title.uppercased())
                .font(WDLType.caption)
                .tracking(1.2)
                .foregroundStyle(Color.wdlInkSecondary)

            Spacer(minLength: WDLSpace.m)

            Text(value)
                .font(WDLFont.display(17, weight: .semibold))
                .foregroundStyle(Color.wdlDeepPurple)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, WDLSpace.m)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.wdlHairline)
                .frame(height: 1)
        }
    }
}

#Preview {
    NavigationStack {
        DetalleView(item: HomeViewModel.sampleItems[0])
    }
}
