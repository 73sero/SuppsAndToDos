import Foundation
import Combine
import SwiftUI

// MARK: - Day Note Model

struct DayNote: Identifiable, Codable, Equatable {
    let id: UUID
    let date: Date
    var text: String
    let createdAt: Date
    var updatedAt: Date

    init(date: Date, text: String) {
        self.id = UUID()
        self.date = Calendar.current.startOfDay(for: date)
        self.text = text
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// MARK: - Today View Model

final class TodayViewModel: ObservableObject {

    // MARK: - Engines
    private let dayEngine = DayEngine()
    private let progressCalculator = ProgressCalculator()
    private let statisticsEngine = StatisticsEngine()
    private let sorter = ItemSorting()
    private let milestoneEngine = MilestoneEngine()
    private let reminderEngine = ReminderEngine()

    // MARK: - Reminder Store
    private let reminderStore: ReminderStore

    // MARK: - Storage Keys
    private let notesStorageKey = "day_notes_v1"
    private let itemsStorageKey = "items_v1"
    private let statusesStorageKey = "statuses_v1"

    // MARK: - Init
    init(reminderStore: ReminderStore) {
        self.reminderStore = reminderStore
        loadNotesFromDisk()
        loadDataFromDisk()
    }

    // MARK: - UI State
    @Published var selectedCategory: ItemCategory = .supplement {
        didSet { refresh() }
    }

    // MARK: - Today State
    @Published private(set) var openStatuses: [ItemStatus] = []
    @Published private(set) var nextItem: Item?
    @Published private(set) var progress: Double = 0.0

    // MARK: - Statistics
    @Published private(set) var todayStats: PeriodStatistics?
    @Published private(set) var weekStats: PeriodStatistics?
    @Published private(set) var monthStats: PeriodStatistics?

    // MARK: - Milestones
    @Published private(set) var milestones: [Milestone] = []

    // MARK: - 📝 DAY NOTES
    @Published private var notesByDay: [Date: DayNote] = [:] {
        didSet { saveNotesToDisk() }
    }

    // MARK: - Internal State
    private(set) var currentDay: AppDay?
    private var items: [Item] = [] {
        didSet { saveDataToDisk() }
    }
    private var schedules: [UUID: Schedule] = [:]
    private var statuses: [ItemStatus] = [] {
        didSet { saveDataToDisk() }
    }

    // MARK: - Load (App Start)

    func load(
        items: [Item],
        schedules: [UUID: Schedule],
        statuses: [ItemStatus],
        settings: SettingsViewModel,
        reference: Date = Date()
    ) {
        if self.items.isEmpty { self.items = items }
        if self.statuses.isEmpty { self.statuses = statuses }

        self.schedules = schedules

        currentDay = dayEngine.handleDayChange(
            lastActiveDay: currentDay,
            dayChangeHour: settings.dayChangeHour,
            items: self.items,
            schedules: schedules,
            statuses: &self.statuses,
            reference: reference
        )

        refresh(reference: reference)
        reminderEngine.syncReminders(items: self.items, schedules: schedules)
    }

    // MARK: - Refresh

    func refresh(reference: Date = Date()) {
        guard let day = currentDay else { return }

        let todayStatuses = statuses.filter {
            Calendar.current.isDate($0.date, inSameDayAs: day.date)
            && item(for: $0)?.type.matches(selectedCategory) == true
        }

        let open = todayStatuses.filter { $0.status == .open }

        openStatuses = sorter.sortOpen(
            statuses: open,
            schedules: schedules,
            on: day.date
        )

        nextItem = openStatuses.first.flatMap { item(for: $0) }

        progress = progressCalculator.completionRate(
            statuses: todayStatuses,
            for: day.date
        )

        milestones = milestoneEngine.milestones(
            statuses: statuses,
            items: items
        )

        todayStats = statisticsEngine.today(statuses: statuses, reference: reference)
        weekStats = statisticsEngine.last7Days(statuses: statuses, reference: reference)
        monthStats = statisticsEngine.last30Days(statuses: statuses, reference: reference)
    }

    // MARK: - Item Actions

    func markDone(statusID: UUID) {
        guard let index = statuses.firstIndex(where: { $0.id == statusID }) else { return }
        statuses[index].status = .done
        statuses[index].completedAt = Date()
        statuses[index].confirmation = .tap
        refresh()
    }

    func markMissed(statusID: UUID) {
        guard let index = statuses.firstIndex(where: { $0.id == statusID }) else { return }
        statuses[index].status = .missed
        refresh()
    }

    func addItem(_ item: Item) {
        items.append(item)

        statuses.append(
            ItemStatus.open(
                itemID: item.id,
                date: Date(),
                slotID: "manual"
            )
        )

        refresh()
    }

    // MARK: - Notes API

    func note(for date: Date) -> DayNote? {
        let key = Calendar.current.startOfDay(for: date)
        return notesByDay[key]
    }

    func addOrUpdateNote(for date: Date, text: String) {
        let key = Calendar.current.startOfDay(for: date)

        if var existing = notesByDay[key] {
            existing.text = text
            existing.updatedAt = Date()
            notesByDay[key] = existing
        } else {
            notesByDay[key] = DayNote(date: key, text: text)
        }
    }

    func deleteNote(for date: Date) {
        let key = Calendar.current.startOfDay(for: date)
        notesByDay.removeValue(forKey: key)
    }

    var allNotes: [Date: DayNote] { notesByDay }
    var allItems: [Item] { items }
    var allStatuses: [ItemStatus] { statuses }

    func statusesForDay(_ date: Date) -> [ItemStatus] {
        statuses.filter {
            Calendar.current.isDate($0.date, inSameDayAs: date)
        }
    }

    func item(for status: ItemStatus) -> Item? {
        items.first { $0.id == status.itemID }
    }

    // MARK: - Reminder

    func presentReminder(_ reminder: Reminder) {
        reminderStore.present(reminder)
    }

    func applyReminder(_ reminder: Reminder) {
        let result = ReminderResultMapper.map(reminder)

        switch result {

        case .open:
            let exists = statuses.contains {
                $0.itemID == reminder.itemID &&
                Calendar.current.isDateInToday($0.date) &&
                $0.status == .open
            }

            if !exists {
                statuses.append(
                    ItemStatus.open(
                        itemID: reminder.itemID,
                        date: Date(),
                        slotID: "reminder"
                    )
                )
            }

        case .done:
            if let index = statuses.firstIndex(where: {
                $0.itemID == reminder.itemID && $0.status == .open
            }) {
                statuses[index].status = .done
                statuses[index].completedAt = Date()
                statuses[index].confirmation = .tap
            }

        case .missed:
            if let index = statuses.firstIndex(where: {
                $0.itemID == reminder.itemID && $0.status == .open
            }) {
                statuses[index].status = .missed
            }

        case .snoozed:
            break
        }

        refresh()
        reminderStore.clear()
    }

    // MARK: - Persistence

    private func saveDataToDisk() {
        if let itemsData = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(itemsData, forKey: itemsStorageKey)
        }

        if let statusesData = try? JSONEncoder().encode(statuses) {
            UserDefaults.standard.set(statusesData, forKey: statusesStorageKey)
        }
    }

    private func loadDataFromDisk() {

        if let itemsData = UserDefaults.standard.data(forKey: itemsStorageKey),
           let decodedItems = try? JSONDecoder().decode([Item].self, from: itemsData) {
            items = decodedItems
        }

        if let statusesData = UserDefaults.standard.data(forKey: statusesStorageKey),
           let decodedStatuses = try? JSONDecoder().decode([ItemStatus].self, from: statusesData) {
            statuses = decodedStatuses
        }
    }

    private func saveNotesToDisk() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let encoded: [String: DayNote] = notesByDay.reduce(into: [:]) { result, entry in
            result[formatter.string(from: entry.key)] = entry.value
        }

        if let data = try? JSONEncoder().encode(encoded) {
            UserDefaults.standard.set(data, forKey: notesStorageKey)
        }
    }

    private func loadNotesFromDisk() {
        guard
            let data = UserDefaults.standard.data(forKey: notesStorageKey),
            let decoded = try? JSONDecoder().decode([String: DayNote].self, from: data)
        else { return }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        notesByDay = decoded.reduce(into: [:]) { result, entry in
            if let date = formatter.date(from: entry.key) {
                result[date] = entry.value
            }
        }
    }
}
