import Foundation

struct ScheduleResolver {

    private let calendar: Calendar = .current

    func isDue(schedule: Schedule, on date: Date) -> Bool {
        switch schedule.repeatRule {
        case .daily:
            return true
        case .custom:
            guard let weekdays = schedule.weekdays else { return false }
            let weekday = calendar.component(.weekday, from: date)
            return weekdays.contains(weekday)
        }
    }

    func dueTime(schedule: Schedule, on date: Date) -> Date {
        let comps = calendar.dateComponents([.hour, .minute], from: schedule.time)
        return calendar.date(
            bySettingHour: comps.hour ?? 0,
            minute: comps.minute ?? 0,
            second: 0,
            of: date
        ) ?? date
    }
}