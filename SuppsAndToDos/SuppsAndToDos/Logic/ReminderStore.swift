import Foundation
import Combine

final class ReminderStore: ObservableObject {

    static let shared = ReminderStore()

    @Published var activeReminder: Reminder?

    private init() {}

    func present(_ reminder: Reminder) {
        activeReminder = reminder
    }

    func clear() {
        activeReminder = nil
    }
}
