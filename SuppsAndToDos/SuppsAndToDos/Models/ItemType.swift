enum ItemType: String, CaseIterable, Identifiable, Codable {
    case supplement
    case todo

    var id: String { rawValue }

    var title: String {
        switch self {
        case .supplement: return "Supplement"
        case .todo: return "Todo"
        }
    }
}
