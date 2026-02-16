import Foundation

extension ItemStatus {

    var isOverdue: Bool {
        guard status == ItemStatusType.open else { return false }

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let statusDay = calendar.startOfDay(for: date)

        return statusDay < today
    }
}
