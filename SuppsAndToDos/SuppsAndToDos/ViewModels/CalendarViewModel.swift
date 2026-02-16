import Foundation
import Combine

final class CalendarViewModel: ObservableObject {

    // MARK: - Snapshot Data
    private var items: [Item] = []
    private var statuses: [ItemStatus] = []
    private var notes: [Date: DayNote] = [:]

    private let calendar = Calendar.current

    // MARK: - Init
    init(
        items: [Item] = [],
        statuses: [ItemStatus] = [],
        notes: [Date: DayNote] = [:]
    ) {
        self.items = items
        self.statuses = statuses
        self.notes = notes
    }

    // MARK: - Load Snapshot
    func load(
        items: [Item],
        statuses: [ItemStatus],
        notes: [Date: DayNote]
    ) {
        self.items = items
        self.statuses = statuses
        self.notes = notes
    }

    // MARK: - Calendar Days (✔️ NIL-SAFE)
    func calendarDays(last days: Int) -> [CalendarDay] {

        let today = calendar.startOfDay(for: Date())

        return (0..<days).map { offset in
            let date = calendar.date(
                byAdding: .day,
                value: -offset,
                to: today
            )!

            let dayStatuses = statusesForDay(date)

            return CalendarDay(
                date: date,
                completed: dayStatuses.filter { $0.status == .done }.count,
                total: dayStatuses.count
            )
        }
    }

    // MARK: - Accessors

    func statusesForDay(_ date: Date) -> [ItemStatus] {
        statuses.filter {
            calendar.isDate($0.date, inSameDayAs: date)
        }
    }

    func item(for status: ItemStatus) -> Item? {
        items.first { $0.id == status.itemID }
    }

    func note(for date: Date) -> DayNote? {
        notes[calendar.startOfDay(for: date)]
    }

    var allItems: [Item] {
        items
    }
}
