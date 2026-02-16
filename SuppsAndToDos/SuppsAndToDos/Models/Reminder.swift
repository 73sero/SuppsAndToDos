import Foundation

struct Reminder: Identifiable {
    let id: UUID
    let itemID: UUID
    let scheduledAt: Date
    let state: ReminderState
}

extension Reminder {
    func with(
        state: ReminderState,
        scheduledAt: Date? = nil
    ) -> Reminder {
        Reminder(
            id: id,
            itemID: itemID,
            scheduledAt: scheduledAt ?? self.scheduledAt,
            state: state
        )
    }
}
