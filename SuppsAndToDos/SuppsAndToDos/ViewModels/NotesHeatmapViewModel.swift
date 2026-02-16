import Foundation
import Combine

final class NotesHeatmapViewModel: ObservableObject {

    /// Key = startOfDay(Date)
    @Published private(set) var notesByDay: [Date: DayNote] = [:]

    private let calendar = Calendar.current

    // MARK: - Inject Notes (from TodayViewModel)

    func update(notes: [Date: DayNote]) {
        notesByDay = notes
    }

    // MARK: - Heatmap Helpers

    func hasNote(on date: Date) -> Bool {
        let key = calendar.startOfDay(for: date)
        return notesByDay[key] != nil
    }

    func noteCount(inLast days: Int) -> Int {
        let today = calendar.startOfDay(for: Date())

        return notesByDay.keys.filter { date in
            guard let diff = calendar.dateComponents([.day], from: date, to: today).day else {
                return false
            }
            return diff >= 0 && diff < days
        }.count
    }

    func intensity(for date: Date) -> Double {
        // aktuell nur 0 / 1 → später erweiterbar (Textlänge etc.)
        hasNote(on: date) ? 1.0 : 0.0
    }
}
