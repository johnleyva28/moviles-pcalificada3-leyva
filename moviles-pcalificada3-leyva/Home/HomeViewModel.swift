import Combine
import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var items: [ItemModel] = HomeViewModel.sampleItems
    @Published private(set) var filteredItems: [ItemModel] = HomeViewModel.sampleItems
    @Published var searchText = "" {
        didSet { applyFilter() }
    }

    /// El filtrado vive en el ViewModel: se recalcula una sola vez por cambio
    /// del texto de búsqueda, no en cada re-render del body de la vista.
    private func applyFilter() {
        let query = searchText.trimmingCharacters(in: .whitespaces).lowercased()

        guard !query.isEmpty else {
            filteredItems = items
            return
        }

        filteredItems = items.filter { item in
            item.name.lowercased().contains(query)
                || item.subtitle.lowercased().contains(query)
                || item.country.lowercased().contains(query)
                || item.plays.lowercased().contains(query)
        }
    }

    /// Tarjetas de resumen que se muestran arriba de la lista.
    nonisolated static let insights: [Insight] = [
        Insight(
            icon: "calendar",
            value: "01 Jul",
            title: "Inicio de Wimbledon",
            detail: "Primera ronda en el All England Club"
        ),
        Insight(
            icon: "person.3.fill",
            value: "128",
            title: "Tenistas en cuadro",
            detail: "64 EMTs · 64 damas"
        ),
        Insight(
            icon: "leaf.fill",
            value: "Césped",
            title: "Superficie",
            detail: "Grass, 78 m por 23.77 m"
        )
    ]

    nonisolated static let sampleItems: [ItemModel] = [
        ItemModel(
            name: "Carlos Alcaraz",
            subtitle: "España · Tenista",
            imageName: "JugadorAlcaraz",
            ranking: 1,
            grandSlamTitles: 4,
            country: "España",
            height: 183,
            plays: "Derecho",
            surface: "Césped"
        ),
        ItemModel(
            name: "Jannik Sinner",
            subtitle: "Italia · Tenista",
            imageName: "JugadorSinner",
            ranking: 2,
            grandSlamTitles: 1,
            country: "Italia",
            height: 188,
            plays: "Derecho",
            surface: "Césped"
        ),
        ItemModel(
            name: "Novak Djokovic",
            subtitle: "Serbia · Tenista",
            imageName: "JugadorDjokovic",
            ranking: 3,
            grandSlamTitles: 24,
            country: "Serbia",
            height: 188,
            plays: "Derecho",
            surface: "Césped"
        ),
        ItemModel(
            name: "Iga Świątek",
            subtitle: "Polonia · Tenista",
            imageName: "JugadorSwiatek",
            ranking: 1,
            grandSlamTitles: 5,
            country: "Polonia",
            height: 176,
            plays: "Izquierdo",
            surface: "Césped"
        ),
        ItemModel(
            name: "Aryna Sabalenka",
            subtitle: "Bielorrusia · Tenista",
            imageName: "JugadorSabalenka",
            ranking: 2,
            grandSlamTitles: 3,
            country: "Bielorrusia",
            height: 182,
            plays: "Derecho",
            surface: "Césped"
        ),
        ItemModel(
            name: "Coco Gauff",
            subtitle: "Estados Unidos · Tenista",
            imageName: "JugadorGauff",
            ranking: 3,
            grandSlamTitles: 1,
            country: "Estados Unidos",
            height: 175,
            plays: "Derecho",
            surface: "Césped"
        ),
        ItemModel(
            name: "Alexander Zverev",
            subtitle: "Alemania · Tenista",
            imageName: "JugadorZverev",
            ranking: 4,
            grandSlamTitles: 0,
            country: "Alemania",
            height: 198,
            plays: "Izquierdo",
            surface: "Césped"
        ),
        ItemModel(
            name: "Jasmine Paolini",
            subtitle: "Italia · Tenista",
            imageName: "JugadorPaolini",
            ranking: 5,
            grandSlamTitles: 1,
            country: "Italia",
            height: 172,
            plays: "Derecho",
            surface: "Césped"
        ),
        ItemModel(
            name: "Andrey Rublev",
            subtitle: "Rusia · Tenista",
            imageName: "JugadorRublev",
            ranking: 6,
            grandSlamTitles: 0,
            country: "Rusia",
            height: 187,
            plays: "Derecho",
            surface: "Césped"
        ),
        ItemModel(
            name: "Mirra Andreeva",
            subtitle: "Rusia · Tenista",
            imageName: "JugadorAndreeva",
            ranking: 7,
            grandSlamTitles: 0,
            country: "Rusia",
            height: 179,
            plays: "Derecho",
            surface: "Césped"
        )
    ]
}

struct Insight: Identifiable, Sendable {
    let id = UUID()
    var icon: String
    var value: String
    var title: String
    var detail: String
}
