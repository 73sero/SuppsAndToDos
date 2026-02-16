import Foundation

enum ItemCategory: String, CaseIterable, Identifiable {
    case supplement = "Supps"
    case todo = "To-Dos"

    var id: String { rawValue }
}
