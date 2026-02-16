import UserNotifications

enum NotificationCategory {
    static let reminder = "REMINDER_CATEGORY"

    static func register() {
        let done = UNNotificationAction(
            identifier: NotificationAction.done.rawValue,
            title: "Done",
            options: [.foreground]
        )

        let snooze = UNNotificationAction(
            identifier: NotificationAction.snooze10.rawValue,
            title: "Snooze 10 min"
        )

        let skip = UNNotificationAction(
            identifier: NotificationAction.skip.rawValue,
            title: "Skip"
        )

        let category = UNNotificationCategory(
            identifier: reminder,
            actions: [done, snooze, skip],
            intentIdentifiers: []
        )

        UNUserNotificationCenter.current()
            .setNotificationCategories([category])
    }
}
