import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var session: SessionStore
    @StateObject private var viewModel = HomeViewModel()

    let onLogout: () -> Void

    var body: some View {
        NavigationStack {
            ZStack {
                Color.wdlMintSoft.ignoresSafeArea()

                ScrollView {
                    LazyVStack(spacing: 12) {
                        header

                        if viewModel.filteredItems.isEmpty {
                            VStack(spacing: 8) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 34))
                                    .foregroundStyle(Color.wdlGreen)
                                Text("Sin resultados")
                                    .font(WDLFont.display(20, weight: .semibold))
                                    .foregroundStyle(Color.wdlGreen)
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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: onLogout) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundStyle(Color.wdlGreen)
                    }
                    .accessibilityLabel("Cerrar sesión")
                }
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("THE CHAMPIONSHIPS")
                .font(WDLFont.sans(11, weight: .medium))
                .tracking(3)
                .foregroundStyle(Color.wdlGreen)

            Text("Las leyendas del tenis")
                .font(WDLFont.display(28, weight: .bold))
                .foregroundStyle(Color.wdlForest)

            Text(session.currentUser.map { "Hola, \($0.name)" } ?? "Bienvenido")
                .font(WDLFont.sans(14))
                .foregroundStyle(Color.wdlInkSecondary)

            searchBar
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 8)
    }

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.wdlGreen)

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
            ZStack {
                Circle()
                    .fill(Color.wdlGrass)
                Image(systemName: item.symbol)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.wdlMint)
            }
            .frame(width: 52, height: 52)

            VStack(alignment: .leading, spacing: 3) {
                Text(item.name)
                    .font(WDLFont.display(18, weight: .semibold))
                    .foregroundStyle(Color.wdlForest)

                Text(item.subtitle)
                    .font(WDLFont.sans(13))
                    .foregroundStyle(Color.wdlInkSecondary)
            }

            Spacer(minLength: 8)

            VStack(alignment: .trailing, spacing: 3) {
                Text("#\(item.ranking)")
                    .font(WDLFont.sans(14, weight: .semibold))
                    .foregroundStyle(Color.wdlGreen)
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
}

#Preview {
    HomeView(onLogout: {})
        .environmentObject(SessionStore())
}
