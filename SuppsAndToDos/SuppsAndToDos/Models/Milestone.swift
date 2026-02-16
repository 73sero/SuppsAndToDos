import Foundation

struct Milestone: Identifiable {
    let id: UUID
    let title: String
    let subtitle: String

    let targetCount: Int
    let currentCount: Int

    let relatedItemID: UUID?
    let relatedItemType: ItemType?

    let isCompleted: Bool
}
