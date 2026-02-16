import Foundation

struct ItemStatistics {
    let itemID: UUID
    let total: Int
    let done: Int
    let missed: Int
    let completionRate: Double
}

struct PeriodStatistics {
    let start: Date
    let end: Date
    let total: Int
    let done: Int
    let missed: Int
    let completionRate: Double
}

final class StatisticsEngine {

    private let calendar: Calendar = .current

    // MARK: - Per Item

    func statisticsForItem(
        itemID: UUID,
        statuses: [ItemStatus]
    ) -> ItemStatistics {

        let filtered = statuses.filter { $0.itemID == itemID }

        let total = filtered.count
        let done = filtered.filter { $0.status == .done }.count
        let missed = filtered.filter { $0.status == .missed }.count

        let rate = total == 0 ? 0.0 : Double(done) / Double(total)

        return ItemStatistics(
            itemID: itemID,
            total: total,
            done: done,
            missed: missed,
            completionRate: rate
        )
    }

    // MARK: - Period

    func statisticsForPeriod(
        statuses: [ItemStatus],
        start: Date,
        end: Date
    ) -> PeriodStatistics {

        let filtered = statuses.filter {
            $0.date >= start && $0.date <= end
        }

        let total = filtered.count
        let done = filtered.filter { $0.status == .done }.count
        let missed = filtered.filter { $0.status == .missed }.count

        let rate = total == 0 ? 0.0 : Double(done) / Double(total)

        return PeriodStatistics(
            start: start,
            end: end,
            total: total,
            done: done,
            missed: missed,
            completionRate: rate
        )
    }

    // MARK: - Convenience Periods

    func today(
        statuses: [ItemStatus],
        reference: Date = Date()
    ) -> PeriodStatistics {

        let start = calendar.startOfDay(for: reference)
        let end = calendar.date(
            byAdding: .day,
            value: 1,
            to: start
        ) ?? reference

        return statisticsForPeriod(
            statuses: statuses,
            start: start,
            end: end
        )
    }

    func last7Days(
        statuses: [ItemStatus],
        reference: Date = Date()
    ) -> PeriodStatistics {

        let end = calendar.startOfDay(for: reference)
        let start = calendar.date(
            byAdding: .day,
            value: -7,
            to: end
        ) ?? end

        return statisticsForPeriod(
            statuses: statuses,
            start: start,
            end: end
        )
    }

    func last30Days(
        statuses: [ItemStatus],
        reference: Date = Date()
    ) -> PeriodStatistics {

        let end = calendar.startOfDay(for: reference)
        let start = calendar.date(
            byAdding: .day,
            value: -30,
            to: end
        ) ?? end

        return statisticsForPeriod(
            statuses: statuses,
            start: start,
            end: end
        )
    }
}