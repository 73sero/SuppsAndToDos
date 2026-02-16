import Foundation

struct ReminderResultMapper {

    static func map(_ reminder: Reminder) -> ReminderResult {
        switch reminder.state {
        case .fired:
            return .open

        case .snoozed(let until):
            return .snoozed(until: until)

        case .skipped:
            return .missed

        case .expired:
            return .missed

        case .pending:
            return .open
        }
    }
}
