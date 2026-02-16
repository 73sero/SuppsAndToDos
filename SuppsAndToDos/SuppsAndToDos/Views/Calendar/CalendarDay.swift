import Foundation

struct CalendarDay: Identifiable {

    let id = UUID()
    let date: Date
    let completed: Int
    let total: Int

    var completionRate: Double {
        total == 0 ? 0 : Double(completed) / Double(total)
    }

    var isPerfectDay: Bool {
        total > 0 && completed == total
    }

    var isEmpty: Bool {
        total == 0
    }
}
