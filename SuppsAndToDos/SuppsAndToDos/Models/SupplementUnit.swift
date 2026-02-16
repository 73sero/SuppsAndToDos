enum SupplementUnit: String, CaseIterable, Identifiable, Codable {
    case mg
    case g
    case ml
    case piece

    var id: String { rawValue }

    var displayName: String {
        rawValue.uppercased()
    }
}
