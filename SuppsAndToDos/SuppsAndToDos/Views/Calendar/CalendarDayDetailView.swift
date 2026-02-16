import SwiftUI

struct CalendarDayDetailView: View {

    // MARK: - Input
    let date: Date
    let statuses: [ItemStatus]
    let items: [Item]

    // MARK: - Environment
    @EnvironmentObject private var todayVM: TodayViewModel
    @Environment(\.dismiss) private var dismiss

    // MARK: - UI State
    @State private var showNoteEditor = false
    @State private var showDeleteConfirm = false

    // MARK: - Derived
    private var note: DayNote? {
        todayVM.note(for: date)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                // MARK: - Header
                Text(date, style: .date)
                    .font(.system(size: 24, weight: .bold))

                // MARK: - Note Section
                noteSection

                Divider().opacity(0.4)

                // MARK: - Items
                VStack(spacing: 12) {
                    ForEach(statuses) { status in
                        if let item = items.first(where: { $0.id == status.itemID }) {
                            CalendarItemRowView(
                                item: item,
                                status: status
                            )
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color.black)
        .foregroundColor(.white)
        .navigationTitle("Day Details")
        .navigationBarTitleDisplayMode(.inline)

        // MARK: - Note Editor
        .sheet(isPresented: $showNoteEditor) {
            NoteEditorView(date: date)
                .environmentObject(todayVM)
        }

        // MARK: - Delete Confirm
        .confirmationDialog(
            "Delete Note?",
            isPresented: $showDeleteConfirm,
            titleVisibility: .visible
        ) {
            Button("Delete Note", role: .destructive) {
                todayVM.deleteNote(for: date)
            }

            Button("Cancel", role: .cancel) {}
        }
    }

    // MARK: - Note UI

    private var noteSection: some View {
        VStack(alignment: .leading, spacing: 10) {

            HStack {
                Text("NOTE")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray)

                Spacer()

                if note != nil {
                    Button("Edit") {
                        showNoteEditor = true
                    }

                    Button(role: .destructive) {
                        showDeleteConfirm = true
                    } label: {
                        Image(systemName: "trash")
                    }
                } else {
                    Button("Add") {
                        showNoteEditor = true
                    }
                }
            }

            if let note {
                Text(note.text)
                    .font(.system(size: 14))
            } else {
                Text("No note for this day.")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
        }
    }
}
