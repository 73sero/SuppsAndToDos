import SwiftUI

struct ReminderView: View {

    @StateObject private var viewModel: ReminderViewModel
    @Environment(\.dismiss) private var dismiss

    init(
        reminder: Reminder,
        onResult: @escaping (Reminder) -> Void
    ) {
        _viewModel = StateObject(
            wrappedValue: ReminderViewModel(
                reminder: reminder,
                onResult: onResult
            )
        )
    }

    var body: some View {
        VStack(spacing: 24) {

            Text("REMINDER")
                .font(.system(size: 22, weight: .bold))

            Text(reminderStateText)
                .font(.system(size: 16))
                .foregroundColor(.gray)

            Spacer()

            VStack(spacing: 12) {

                Button("Done") {
                    viewModel.fire()
                    dismiss()
                }

                Button("Snooze 10 min") {
                    viewModel.snooze(minutes: 10)
                    dismiss()
                }

                Button("Skip") {
                    viewModel.skip()
                    dismiss()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }

    private var reminderStateText: String {
        switch viewModel.reminder.state {
        case .pending:
            return "Reminder"
        case .fired:
            return "Time to act"
        case .snoozed(let until):
            return "Snoozed until \(until.formatted(date: .omitted, time: .shortened))"
        case .skipped:
            return "Skipped"
        case .expired:
            return "Expired"
        }
    }
}
