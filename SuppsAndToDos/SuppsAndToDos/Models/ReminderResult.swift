import Foundation

enum ReminderResult {
    case open
    case done
    case missed
    case snoozed(until: Date)
}
