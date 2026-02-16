import Foundation

struct Item: Identifiable, Codable {
    let id: UUID
    let title: String
    let type: ItemType
    let isActive: Bool
    let createdAt: Date

    let unit: SupplementUnit?
    let amount: Double?
}
