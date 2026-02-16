import SwiftUI

struct ReminderSheetView: View {

    @StateObject var viewModel: ReminderViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {

            Capsule()
                .fill(Color.white.opacity(0.3))
                .frame(width: 40, height: 5)
                .padding(.top, 8)

            VStack(spacing: 8) {
                Text("REMINDER")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.gray)

                Text(reminderTitle)
                    .font(.system(size: 22, weight: .bold))
                    .multilineTextAlignment(.center)
            }

            Divider()

            VStack(spacing: 12) {

                actionButton(
                    title: "Done",
                    icon: "checkmark.circle.fill"
                ) {
                    viewModel.fire()
                    dismiss()
                }

                actionButton(
                    title: "Snooze 10 min",
                    icon: "clock.fill"
                ) {
                    viewModel.snooze(minutes: 10)
                    dismiss()
                }

                actionButton(
                    title: "Skip",
                    icon: "xmark.circle.fill"
                ) {
                    viewModel.skip()
                    dismiss()
                }
            }

            Spacer()
        }
        .padding()
        .background(Color.black)
        .foregroundColor(.white)
        .presentationDetents([.medium])
    }

    private var reminderTitle: String {
        "Time for your task"
    }

    private func actionButton(
        title: String,
        icon: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.12))
            )
        }
    }
}
