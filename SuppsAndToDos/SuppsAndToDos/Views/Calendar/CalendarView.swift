import SwiftUI

struct CalendarView: View {

    @EnvironmentObject private var calendarVM: CalendarViewModel
    @EnvironmentObject private var todayVM: TodayViewModel

    // MARK: - Search
    @State private var searchText: String = ""

    // MARK: - Days
    private var days: [CalendarDay] {
        let allDays = calendarVM.calendarDays(last: 30)

        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return allDays
        }

        return allDays.filter { day in
            guard let note = todayVM.note(for: day.date)?.text else {
                return false
            }
            return note.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    header
                    searchField

                    if days.isEmpty {
                        emptyState
                    } else {
                        VStack(spacing: 14) {
                            ForEach(days) { day in

                                let statuses = calendarVM.statusesForDay(day.date)

                                let supplementCount = statuses.filter {
                                    calendarVM.item(for: $0)?.type == .supplement
                                }.count

                                let todoCount = statuses.filter {
                                    calendarVM.item(for: $0)?.type == .todo
                                }.count

                                let notePreview =
                                    todayVM.note(for: day.date)?
                                        .text
                                        .trimmingCharacters(in: .whitespacesAndNewlines)

                                NavigationLink {
                                    CalendarDayDetailView(
                                        date: day.date,
                                        statuses: statuses,
                                        items: calendarVM.allItems
                                    )
                                } label: {
                                    CalendarDayRowView(
                                        day: day,
                                        supplementCount: supplementCount,
                                        todoCount: todoCount,
                                        notePreview: notePreview?.isEmpty == false
                                            ? notePreview
                                            : nil
                                    )
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Color.black)
            .foregroundColor(.white)
            .navigationTitle("Calendar")
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("CALENDAR")
                .font(.system(size: 26, weight: .bold))

            Text("Search your notes")
                .font(.system(size: 13))
                .foregroundColor(.gray)
        }
    }

    // MARK: - Search Field

    private var searchField: some View {
        TextField("Search notes…", text: $searchText)
            .textFieldStyle(.plain)
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.06))
            )
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 12) {
            Text("No matching notes")
                .font(.system(size: 16, weight: .medium))

            Text("Try a different keyword.")
                .font(.system(size: 13))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 40)
    }
}
