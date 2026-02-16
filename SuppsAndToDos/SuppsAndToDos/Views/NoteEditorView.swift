import SwiftUI

struct NoteEditorView: View {

    @EnvironmentObject private var todayVM: TodayViewModel
    @Environment(\.dismiss) private var dismiss

    let date: Date

    @State private var text: String = ""
    @State private var didLoadInitialText = false

    private var existingNote: DayNote? {
        todayVM.note(for: date)
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {

                // MARK: - Text Editor
                TextEditor(text: $text)
                    .padding(16)
                    .background(Color.white.opacity(0.06))
                    .cornerRadius(14)
                    .padding()
                    .scrollContentBackground(.hidden)

                // MARK: - Placeholder
                if text.isEmpty {
                    Text("Write your note for this day…")
                        .foregroundColor(.gray.opacity(0.6))
                        .padding(.horizontal, 24)
                        .padding(.top, 24)
                }
            }
            .navigationTitle("Note")
            .navigationBarTitleDisplayMode(.inline)

            .toolbar {

                // MARK: - Cancel
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        autoSaveIfNeeded()
                        dismiss()
                    }
                }

                // MARK: - Save
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                        dismiss()
                    }
                    .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }

                // MARK: - Delete (nur wenn Note existiert)
                if existingNote != nil {
                    ToolbarItem(placement: .bottomBar) {
                        Button(role: .destructive) {
                            todayVM.deleteNote(for: date)
                            dismiss()
                        } label: {
                            Label("Delete Note", systemImage: "trash")
                        }
                    }
                }
            }

            .onAppear {
                guard !didLoadInitialText else { return }
                didLoadInitialText = true

                if let note = existingNote {
                    text = note.text
                }
            }
        }
        .background(Color.black)
        .foregroundColor(.white)
    }

    // MARK: - Save Helpers

    private func save() {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        todayVM.addOrUpdateNote(for: date, text: trimmed)
    }

    private func autoSaveIfNeeded() {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty {
            return
        }

        if existingNote?.text != trimmed {
            todayVM.addOrUpdateNote(for: date, text: trimmed)
        }
    }
}
