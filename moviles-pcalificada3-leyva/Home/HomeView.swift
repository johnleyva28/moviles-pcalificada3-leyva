import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var session: SessionStore
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Color.wdlPurpleSoft.ignoresSafeArea()

                ScrollView {
                    LazyVStack(spacing: 12) {
                        header

                        insights

                        if viewModel.filteredItems.isEmpty {
                            VStack(spacing: 8) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 34))
                                    .foregroundStyle(Color.wdlPurple)
                                Text("Sin resultados")
                                    .font(WDLFont.display(20, weight: .semibold))
                                    .foregroundStyle(Color.wdlPurple)
                                Text("No hay tenistas que coincidan con «\(viewModel.searchText)»")
                                    .font(WDLFont.sans(13))
                                    .foregroundStyle(Color.wdlInkSecondary)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.vertical, 48)
                        } else {
                            ForEach(viewModel.filteredItems) { item in
                                NavigationLink(value: item) {
                                    row(item)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle("Wimbledon")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: ItemModel.self) { item in
                DetalleView(item: item)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("THE CHAMPIONSHIPS")
                .font(WDLFont.sans(11, weight: .medium))
                .tracking(3)
                .foregroundStyle(Color.wdlPurple)

            Text("Las leyendas del tenis")
                .font(WDLFont.display(28, weight: .bold))
                .foregroundStyle(Color.wdlDeepPurple)

            Text(session.currentUser.map { "Hola, \($0.name)" } ?? "Bienvenido")
                .font(WDLFont.sans(14))
                .foregroundStyle(Color.wdlInkSecondary)

            searchBar
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 8)
    }

    private var insights: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(HomeViewModel.insights) { insight in
                    insightCard(insight)
                }
            }
            .padding(.vertical, 4)
        }
    }

    private func insightCard(_ insight: Insight) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: insight.icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.wdlPurple)

            Text(insight.value)
                .font(WDLFont.display(20, weight: .bold))
                .foregroundStyle(Color.wdlDeepPurple)

            Text(insight.title)
                .font(WDLFont.sans(12, weight: .semibold))
                .foregroundStyle(Color.wdlPurple)

            Text(insight.detail)
                .font(WDLFont.sans(11))
                .foregroundStyle(Color.wdlInkSecondary)
                .lineLimit(2)
        }
        .frame(width: 148, alignment: .leading)
        .padding(14)
        .background(.white, in: RoundedRectangle(cornerRadius: 14))
        .overlay {
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(Color.wdlBorder, lineWidth: 1)
        }
    }

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.wdlPurple)

            TextField("Buscar tenista o país", text: $viewModel.searchText)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .font(WDLFont.sans(15))

            if !viewModel.searchText.isEmpty {
                Button {
                    viewModel.searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.wdlInkSecondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(12)
        .background(.white, in: RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.wdlBorder, lineWidth: 1)
        }
        .padding(.top, 4)
    }

    private func row(_ item: ItemModel) -> some View {
        HStack(spacing: 14) {
            avatar(item)

            VStack(alignment: .leading, spacing: 3) {
                Text(item.name)
                    .font(WDLFont.display(18, weight: .semibold))
                    .foregroundStyle(Color.wdlDeepPurple)

                Text(item.subtitle)
                    .font(WDLFont.sans(13))
                    .foregroundStyle(Color.wdlInkSecondary)
            }

            Spacer(minLength: 8)

            VStack(alignment: .trailing, spacing: 3) {
                Text("#\(item.ranking)")
                    .font(WDLFont.sans(14, weight: .semibold))
                    .foregroundStyle(Color.wdlPurple)
                Text("Ranking")
                    .font(WDLFont.sans(10))
                    .foregroundStyle(Color.wdlInkSecondary)
            }

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(Color.wdlInkSecondary)
        }
        .padding(14)
        .background(.white, in: RoundedRectangle(cornerRadius: 14))
        .overlay {
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(Color.wdlBorder, lineWidth: 1)
        }
    }

    private func avatar(_ item: ItemModel) -> some View {
        ZStack {
            Circle()
                .fill(Color.wdlPurple)
            Image(item.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 52, height: 52)
                .clipShape(Circle())
        }
        .frame(width: 52, height: 52)
        .overlay {
            Circle().strokeBorder(Color.wdlMint, lineWidth: 2)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(SessionStore())
}
