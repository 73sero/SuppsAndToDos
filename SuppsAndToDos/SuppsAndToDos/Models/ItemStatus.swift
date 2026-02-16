import Foundation

struct ItemStatus: Identifiable, Codable {

    let id: UUID
    let itemID: UUID
    let date: Date
    let slotID: String

    var status: ItemStatusType
    var completedAt: Date?
    var confirmation: ConfirmationMethod?
}

extension ItemStatus {

    static func open(
        itemID: UUID,
        date: Date,
        slotID: String
    ) -> ItemStatus {
        ItemStatus(
            id: UUID(),
            itemID: itemID,
            date: date,
            slotID: slotID,
            status: ItemStatusType.open,
            completedAt: nil,
            confirmation: nil
        )
    }
}
