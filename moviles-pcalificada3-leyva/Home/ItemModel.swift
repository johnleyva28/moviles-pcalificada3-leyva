import Foundation

struct ItemModel: Identifiable, Hashable {
    let id: UUID = UUID()
    var name: String
    var subtitle: String
    var symbol: String
    var ranking: Int
    var grandSlamTitles: Int
    var country: String
    var height: Int
    var plays: String
    var surface: String
}
