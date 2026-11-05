import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var session: SessionStore
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Color.wdlMint.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: WDLSpace.l) {
                        header
                        statsBand

                        if viewModel.filteredItems.isEmpty {
                            emptyState
                        } else {
                            playerList
                        }
                    }
                    .padding(.horizontal, WDLSpace.l)
                    .padding(.bottom, WDLSpace.xl)
                }
            }
            .navigationTitle("Wimbledon")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: ItemModel.self) { item in
                DetalleView(item: item)
            }
        }
    }

    // MARK: - Encabezado

    private var header: some View {
        VStack(alignment: .leading, spacing: WDLSpace.s) {
            Text("THE CHAMPIONSHIPS")
                .font(WDLType.caption)
                .tracking(3)
                .foregroundStyle(Color.wdlGreen)

            Text("Las leyendas del tenis")
                .font(WDLType.display)
                .foregroundStyle(Color.wdlDeepPurple)

            Text(session.currentUser.map { "Hola, \($0.name)" } ?? "Bienvenido")
                .font(WDLType.body)
                .foregroundStyle(Color.wdlInkSecondary)

            searchBar
                .padding(.top, WDLSpace.xs)
        }
        .padding(.top, WDLSpace.s)
    }

    private var searchBar: some View {
        HStack(spacing: WDLSpace.m) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.wdlGreen)

            TextField("Buscar tenista o país", text: $viewModel.searchText)
                .font(WDLType.body)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

            if !viewModel.searchText.isEmpty {
                Button {
                    viewModel.searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.wdlInkSecondary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Limpiar búsqueda")
            }
        }
        .padding(.horizontal, WDLSpace.m)
        .padding(.vertical, WDLSpace.m)
        .background(Color.wdlPaper, in: RoundedRectangle(cornerRadius: WDLRadius.control))
        .overlay {
            RoundedRectangle(cornerRadius: WDLRadius.control)
                .strokeBorder(Color.wdlBorder, lineWidth: 1)
        }
    }

    // MARK: - Banda de estadísticas

    /// Una sola banda con tres datos separados por filetes, en vez de tres tarjetas.
    private var statsBand: some View {
        HStack(spacing: 0) {
            stat(HomeViewModel.insights[0])
            divider
            stat(HomeViewModel.insights[1])
            divider
            stat(HomeViewModel.insights[2])
        }
        .padding(.vertical, WDLSpace.m)
        .background(Color.wdlPaper, in: RoundedRectangle(cornerRadius: WDLRadius.container))
        .overlay {
            RoundedRectangle(cornerRadius: WDLRadius.container)
                .strokeBorder(Color.wdlBorder, lineWidth: 1)
        }
    }

    private var divider: some View {
        Rectangle()
            .fill(Color.wdlHairline)
            .frame(width: 1, height: 34)
    }

    private func stat(_ insight: Insight) -> some View {
        VStack(spacing: WDLSpace.xs) {
            Text(insight.value)
                .font(WDLFont.display(17, weight: .bold))
                .foregroundStyle(Color.wdlDeepPurple)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Text(insight.title)
                .font(WDLType.caption)
                .foregroundStyle(Color.wdlGreen)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
    }

    // MARK: - Lista

    /// Una lámina continua con separadores, no una tarjeta por fila.
    private var playerList: some View {
        VStack(spacing: 0) {
            ForEach(Array(viewModel.filteredItems.enumerated()), id: \.element.id) { index, item in
                NavigationLink(value: item) {
                    row(item)
                }
                .buttonStyle(.plain)

                if index < viewModel.filteredItems.count - 1 {
                    Rectangle()
                        .fill(Color.wdlHairline)
                        .frame(height: 1)
                        .padding(.leading, 72)
                }
            }
        }
        .background(Color.wdlPaper, in: RoundedRectangle(cornerRadius: WDLRadius.container))
        .overlay {
            RoundedRectangle(cornerRadius: WDLRadius.container)
                .strokeBorder(Color.wdlBorder, lineWidth: 1)
        }
    }

    private func row(_ item: ItemModel) -> some View {
        HStack(spacing: WDLSpace.m) {
            avatar(item)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(WDLFont.display(17, weight: .semibold))
                    .foregroundStyle(Color.wdlDeepPurple)
                    .lineLimit(1)

                Text(item.subtitle)
                    .font(WDLType.footnote)
                    .foregroundStyle(Color.wdlInkSecondary)
                    .lineLimit(1)
            }

            Spacer(minLength: WDLSpace.s)

            Text("#\(item.ranking)")
                .font(WDLType.subhead)
                .monospacedDigit()
                .foregroundStyle(Color.wdlGreen)

            Image(systemName: "chevron.right")
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(Color.wdlInkSecondary)
        }
        .padding(.horizontal, WDLSpace.m)
        .padding(.vertical, WDLSpace.m)
        .contentShape(Rectangle())
    }

    private func avatar(_ item: ItemModel) -> some View {
        Image(item.imageName)
            .resizable()
            .scaledToFill()
            .frame(width: 44, height: 44)
            .clipShape(Circle())
            .overlay {
                Circle().strokeBorder(Color.wdlPaper, lineWidth: 2)
            }
    }

    // MARK: - Estado vacío

    private var emptyState: some View {
        VStack(spacing: WDLSpace.m) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 28, weight: .light))
                .foregroundStyle(Color.wdlGreen)

            Text("Ningún tenista coincide")
                .font(WDLFont.display(17, weight: .semibold))
                .foregroundStyle(Color.wdlDeepPurple)

            Text("Prueba con un nombre, un país o la mano que juega.")
                .font(WDLType.footnote)
                .foregroundStyle(Color.wdlInkSecondary)
                .multilineTextAlignment(.center)

            Button("Limpiar búsqueda") {
                viewModel.searchText = ""
            }
            .font(WDLType.subhead)
            .foregroundStyle(Color.wdlGreen)
            .padding(.top, WDLSpace.xs)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, WDLSpace.xl)
        .padding(.horizontal, WDLSpace.l)
        .background(Color.wdlPaper, in: RoundedRectangle(cornerRadius: WDLRadius.container))
        .overlay {
            RoundedRectangle(cornerRadius: WDLRadius.container)
                .strokeBorder(Color.wdlBorder, lineWidth: 1)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(SessionStore())
}
