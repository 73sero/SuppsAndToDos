import Foundation

final class ReminderStateEngine {

    func nextState(
        reminder: Reminder,
        action: ReminderAction
    ) -> Reminder {

        switch action {

        case .fire:
            return Reminder(
                id: reminder.id,
                itemID: reminder.itemID,
                scheduledAt: reminder.scheduledAt,
                state: .fired
            )

        case .snooze(let minutes):
            let newDate = Calendar.current.date(
                byAdding: .minute,
                value: minutes,
                to: Date()
            ) ?? Date()

            return Reminder(
                id: reminder.id,
                itemID: reminder.itemID,
                scheduledAt: newDate,
                state: .snoozed(until: newDate)
            )

        case .skip:
            return Reminder(
                id: reminder.id,
                itemID: reminder.itemID,
                scheduledAt: reminder.scheduledAt,
                state: .skipped
            )

        case .expire:
            return Reminder(
                id: reminder.id,
                itemID: reminder.itemID,
                scheduledAt: reminder.scheduledAt,
                state: .expired
            )
        }
    }
}
