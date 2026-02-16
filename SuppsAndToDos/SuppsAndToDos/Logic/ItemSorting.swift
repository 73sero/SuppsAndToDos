import Foundation

struct ItemSorting {

    func sortOpen(
        statuses: [ItemStatus],
        schedules: [UUID: Schedule],
        on date: Date
    ) -> [ItemStatus] {

        statuses.sorted { a, b in

            // 1. Overdue zuerst
            if a.isOverdue != b.isOverdue {
                return a.isOverdue
            }

            // 2. Nach Uhrzeit sortieren
            let ta = dueTime(for: a, schedules: schedules, on: date)
            let tb = dueTime(for: b, schedules: schedules, on: date)

            if ta != tb {
                return ta < tb
            }

            // 3. Fallback: Slot-ID
            return a.slotID < b.slotID
        }
    }

    private func dueTime(
        for status: ItemStatus,
        schedules: [UUID: Schedule],
        on date: Date
    ) -> Date {

        guard let schedule = schedules[status.itemID] else {
            return date
        }

        let cal = Calendar.current
        let comps = cal.dateComponents([.hour, .minute], from: schedule.time)

        return cal.date(
            bySettingHour: comps.hour ?? 0,
            minute: comps.minute ?? 0,
            second: 0,
            of: date
        ) ?? date
    }
}
