import Foundation

// MARK: - Widget Models

struct WidgetItemSnapshot: Identifiable {
    let id: UUID
    let title: String
    let time: String
    let status: ItemStatusType
}

struct WidgetStatisticsSnapshot {
    let todayRate: Double
    let weekRate: Double
}

struct WidgetSnapshot {
    let progress: Double
    let nextItem: WidgetItemSnapshot?
    let items: [WidgetItemSnapshot]
    let statistics: WidgetStatisticsSnapshot
}

// MARK: - Builder

struct WidgetSnapshotBuilder {

    private let progressCalculator = ProgressCalculator()
    private let statisticsEngine = StatisticsEngine()
    private let calendar: Calendar = .current

    func build(
        statuses: [ItemStatus],
        items: [Item],
        reference: Date = Date()
    ) -> WidgetSnapshot {

        let todayStatuses = statuses.filter {
            calendar.isDate($0.date, inSameDayAs: reference)
        }

        let openStatuses = todayStatuses.filter { $0.status == .open }

        let itemSnapshots = openStatuses.compactMap { status -> WidgetItemSnapshot? in
            guard let item = items.first(where: { $0.id == status.itemID }) else {
                return nil
            }

            return WidgetItemSnapshot(
                id: status.id,
                title: item.title,
                time: timeString(from: status.date),
                status: status.status
            )
        }

        let progress = progressCalculator.completionRate(
            statuses: statuses,
            for: reference
        )

        let todayStats = statisticsEngine.today(
            statuses: statuses,
            reference: reference
        )

        let weekStats = statisticsEngine.last7Days(
            statuses: statuses,
            reference: reference
        )

        let statsSnapshot = WidgetStatisticsSnapshot(
            todayRate: todayStats.completionRate,
            weekRate: weekStats.completionRate
        )

        return WidgetSnapshot(
            progress: progress,
            nextItem: itemSnapshots.first,
            items: Array(itemSnapshots.prefix(4)),
            statistics: statsSnapshot
        )
    }

    // MARK: - Helpers

    private func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}