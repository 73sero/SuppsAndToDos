import Foundation
import UserNotifications

final class ReminderEngine {

    func syncReminders(
        items: [Item],
        schedules: [UUID: Schedule]
    ) {
        let center = UNUserNotificationCenter.current()

        // Erst alles entfernen, dann sauber neu planen
        center.removeAllPendingNotificationRequests()

        for item in items {
            guard let schedule = schedules[item.id] else { continue }
            guard schedule.notificationsEnabled else { continue }

            scheduleTriggers(for: item, schedule: schedule)
                .forEach { trigger in
                    let content = UNMutableNotificationContent()
                    content.title = item.title
                    content.body = notificationBody(for: item)
                    content.sound = .default
                    content.categoryIdentifier = NotificationCategory.reminder
                    content.userInfo = [
                        "itemID": item.id.uuidString
                    ]

                    let identifier = "\(item.id.uuidString)-\(trigger.identifier)"

                    let request = UNNotificationRequest(
                        identifier: identifier,
                        content: content,
                        trigger: trigger.trigger
                    )

                    center.add(request)
                }
        }
    }

    // MARK: - Helpers

    private func scheduleTriggers(
        for item: Item,
        schedule: Schedule
    ) -> [(identifier: String, trigger: UNCalendarNotificationTrigger)] {

        var results: [(String, UNCalendarNotificationTrigger)] = []

        let calendar = Calendar.current
        let time = calendar.dateComponents([.hour, .minute], from: schedule.time)

        let weekdays = schedule.weekdays ?? Set(1...7)

        for day in weekdays {
            var components = time
            components.weekday = day

            let trigger = UNCalendarNotificationTrigger(
                dateMatching: components,
                repeats: true
            )

            results.append(
                (identifier: "weekday-\(day)", trigger: trigger)
            )
        }

        return results
    }

    private func notificationBody(for item: Item) -> String {
        switch item.type {
        case .supplement:
            if let amount = item.amount, let unit = item.unit {
                return "\(amount) \(unit.displayName)"
            } else {
                return "Time to take it"
            }
        case .todo:
            return "Time to do it"
        }
    }
}
