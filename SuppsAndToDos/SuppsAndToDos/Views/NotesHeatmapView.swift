import SwiftUI

// MARK: - Identifiable Date Wrapper

private struct NoteDate: Identifiable {
    let id = UUID()
    let date: Date
}

struct NotesHeatmapView: View {

    @EnvironmentObject private var todayVM: TodayViewModel

    // MARK: - Config
    private let daysBack: Int = 90
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 7)

    // MARK: - Sheet State
    @State private var selectedNoteDate: NoteDate?

    // MARK: - Dates
    private var dates: [Date] {
        (0..<daysBack).compactMap {
            Calendar.current.date(byAdding: .day, value: -$0, to: Date())
        }.reversed()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            header

            LazyVGrid(columns: columns, spacing: 6) {
                ForEach(dates, id: \.self) { date in
                    heatmapCell(for: date)
                }
            }
        }
        .padding()
        .background(Color.black)

        // MARK: - Sheet
        .sheet(item: $selectedNoteDate) { wrapper in
            NoteEditorView(date: wrapper.date)
                .environmentObject(todayVM)
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("NOTE ACTIVITY")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.gray)

            Text("Last \(daysBack) days")
                .font(.system(size: 12))
                .foregroundColor(.gray.opacity(0.7))
        }
    }

    // MARK: - Cell

    private func heatmapCell(for date: Date) -> some View {

        let noteText = todayVM.note(for: date)?.text ?? ""
        let intensity = noteIntensity(noteText)

        return RoundedRectangle(cornerRadius: 4)
            .fill(intensity)
            .frame(height: 18)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.white.opacity(0.04))
            )
            .onTapGesture {
                selectedNoteDate = NoteDate(date: date)
            }
            .accessibilityLabel(Text(date.formatted(date: .abbreviated, time: .omitted)))
    }

    // MARK: - Intensity Logic

    private func noteIntensity(_ text: String) -> Color {
        let length = text.trimmingCharacters(in: .whitespacesAndNewlines).count

        switch length {
        case 0:
            return Color.white.opacity(0.05)
        case 1..<40:
            return Color.green.opacity(0.25)
        case 40..<120:
            return Color.green.opacity(0.45)
        case 120..<300:
            return Color.green.opacity(0.7)
        default:
            return Color.green
        }
    }
}
