import Foundation

struct ProgressCalculator {

    func completionRate(
        statuses: [ItemStatus],
        for date: Date
    ) -> Double {

        let today = statuses.filter {
            Calendar.current.isDate($0.date, inSameDayAs: date)
        }

        guard !today.isEmpty else { return 0.0 }

        let done = today.filter { $0.status == .done }.count
        return Double(done) / Double(today.count)
    }
}