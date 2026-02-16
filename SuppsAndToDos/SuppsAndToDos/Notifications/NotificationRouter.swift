import UserNotifications

final class NotificationRouter: NSObject, UNUserNotificationCenterDelegate {

    static let shared = NotificationRouter()

    var onReminderAction: ((ReminderAction, UUID) -> Void)?

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {

        guard
            let itemIDString = response.notification.request.content.userInfo["itemID"] as? String,
            let itemID = UUID(uuidString: itemIDString)
        else { return }

        let action: ReminderAction

        switch response.actionIdentifier {
        case NotificationAction.done.rawValue:
            action = .fire

        case NotificationAction.snooze10.rawValue:
            action = .snooze(minutes: 10)

        case NotificationAction.skip.rawValue:
            action = .skip

        default:
            return
        }

        onReminderAction?(action, itemID)
    }
}
