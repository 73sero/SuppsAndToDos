import Foundation
import Combine

final class ReminderViewModel: ObservableObject {

    @Published private(set) var reminder: Reminder

    private let engine = ReminderStateEngine()
    private let onResult: (Reminder) -> Void

    init(
        reminder: Reminder,
        onResult: @escaping (Reminder) -> Void
    ) {
        self.reminder = reminder
        self.onResult = onResult
    }

    func fire() {
        reminder = engine.nextState(reminder: reminder, action: .fire)
        onResult(reminder)
    }

    func snooze(minutes: Int) {
        reminder = engine.nextState(reminder: reminder, action: .snooze(minutes: minutes))
        onResult(reminder)
    }

    func skip() {
        reminder = engine.nextState(reminder: reminder, action: .skip)
        onResult(reminder)
    }

    func expire() {
        reminder = engine.nextState(reminder: reminder, action: .expire)
        onResult(reminder)
    }
}
