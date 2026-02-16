import Foundation

final class DayEngine {

    private let calendar: Calendar = .current

    func handleDayChange(
        lastActiveDay: AppDay?,
        dayChangeHour: Int,
        items: [Item],
        schedules: [UUID: Schedule],
        statuses: inout [ItemStatus],
        reference: Date = Date()
    ) -> AppDay {

        let today = currentDay(reference: reference, hour: dayChangeHour)

        guard let last = lastActiveDay else {
            createStatuses(for: today, items, schedules, &statuses)
            return today
        }

        if last.date < today.date {
            markMissedUntil(to: today.date, statuses: &statuses)
            createStatuses(for: today, items, schedules, &statuses)
        }

        return today
    }

    private func currentDay(reference: Date, hour: Int) -> AppDay {
        let base = calendar.startOfDay(for: reference)
        let shifted = calendar.date(byAdding: .hour, value: hour, to: base) ?? base

        if reference < shifted {
            let prev = calendar.date(byAdding: .day, value: -1, to: base) ?? base
            return AppDay(date: calendar.startOfDay(for: prev))
        }

        return AppDay(date: base)
    }

    private func markMissedUntil(
        to end: Date,
        statuses: inout [ItemStatus]
    ) {
        for i in statuses.indices {
            if statuses[i].date < end && statuses[i].status == .open {
                statuses[i].status = .missed
            }
        }
    }

    private func createStatuses(
        for day: AppDay,
        _ items: [Item],
        _ schedules: [UUID: Schedule],
        _ statuses: inout [ItemStatus]
    ) {
        let resolver = ScheduleResolver()

        for item in items where item.isActive {
            guard let schedule = schedules[item.id] else { continue }
            guard resolver.isDue(schedule: schedule, on: day.date) else { continue }

            let exists = statuses.contains {
                $0.itemID == item.id &&
                $0.slotID == schedule.slotID &&
                calendar.isDate($0.date, inSameDayAs: day.date)
            }

            if exists { continue }

            statuses.append(
                ItemStatus(
                    id: UUID(),
                    itemID: item.id,
                    date: day.date,
                    slotID: schedule.slotID,
                    status: .open,
                    completedAt: nil,
                    confirmation: nil
                )
            )
        }
    }
}
