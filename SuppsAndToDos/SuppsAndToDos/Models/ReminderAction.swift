import Foundation

enum ReminderAction {
    case fire
    case snooze(minutes: Int)
    case skip
    case expire
}
