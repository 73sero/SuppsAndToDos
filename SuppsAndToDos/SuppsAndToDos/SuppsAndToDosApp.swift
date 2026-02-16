import SwiftUI
import UserNotifications

@main
struct SuppsAndToDosApp: App {

    @StateObject private var todayViewModel =
        TodayViewModel(reminderStore: .shared)

    init() {
        NotificationCategory.register()
        UNUserNotificationCenter.current().delegate = NotificationRouter.shared

        NotificationRouter.shared.onReminderAction = { action, itemID in
            let reminder = Reminder(
                id: UUID(),
                itemID: itemID,
                scheduledAt: Date(),
                state: .pending
            )

            let engine = ReminderStateEngine()
            let updated = engine.nextState(reminder: reminder, action: action)

            ReminderStore.shared.present(updated)
        }
    }

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(todayViewModel)
                .preferredColorScheme(.dark)
        }
    }
}
