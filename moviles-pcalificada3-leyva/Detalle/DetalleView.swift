import SwiftUI

struct DetalleView: View {
    let item: ItemModel

    var body: some View {
        ZStack {
            Color.wdlMintSoft.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    hero

                    VStack(alignment: .leading, spacing: 14) {
                        Text(item.name)
                            .font(WDLFont.display(30, weight: .bold))
                            .foregroundStyle(Color.wdlForest)

                        Text(item.subtitle)
                            .font(WDLFont.sans(15))
                            .foregroundStyle(Color.wdlInkSecondary)

                        Divider().overlay(Color.wdlBorder)

                        attributes
                    }
                    .padding(20)
                    .background(.white, in: RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 28)
            }
        }
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var hero: some View {
        ZStack {
            LinearGradient(
                colors: [.wdlGrass, .wdlForest],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Image(item.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 220)
                .clipped()
                .overlay(Color.wdlForest.opacity(0.35))
        }
        .frame(height: 220)
        .frame(maxWidth: .infinity)
    }

    private var attributes: some View {
        VStack(spacing: 0) {
            attributeRow(title: "Ranking ATP", value: "#\(item.ranking)")
            attributeRow(title: "Títulos Grand Slam", value: "\(item.grandSlamTitles)")
            attributeRow(title: "País", value: item.country)
            attributeRow(title: "Altura", value: "\(item.height) cm")
            attributeRow(title: "Mano dominante", value: item.plays)
            attributeRow(title: "Superficie", value: item.surface)
        }
    }

    private func attributeRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(WDLFont.sans(14))
                .foregroundStyle(Color.wdlInkSecondary)

            Spacer()

            Text(value)
                .font(WDLFont.sans(15, weight: .semibold))
                .foregroundStyle(Color.wdlForest)
        }
        .padding(.vertical, 11)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.wdlBorder)
                .frame(height: 1)
        }
    }
}

#Preview {
    NavigationStack {
        DetalleView(item: HomeViewModel.sampleItems[0])
    }
}
