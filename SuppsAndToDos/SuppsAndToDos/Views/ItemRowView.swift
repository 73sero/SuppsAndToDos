import SwiftUI

struct ItemRowView: View {

    let item: Item
    let status: ItemStatus
    let onDone: () -> Void
    let onSkip: (() -> Void)? = nil
    let onSnooze: (() -> Void)? = nil

    @State private var pressed = false

    var body: some View {
        HStack(spacing: 16) {

            // MARK: - Status Indicator
            statusIndicator
                .onTapGesture {
                    guard status.status == .open else { return }
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        onDone()
                    }
                }

            // MARK: - Content
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(titleColor)
                    .lineLimit(1)

                if let subtitle = subtitleText {
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }

            Spacer()
        }
        .padding(16)
        .background(rowBackground)
        .scaleEffect(pressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.25, dampingFraction: 0.8), value: pressed)
        .animation(.easeInOut(duration: 0.2), value: status.status)
        .onLongPressGesture(
            minimumDuration: 0.01,
            pressing: { isPressing in
                pressed = isPressing
            },
            perform: {}
        )

        // MARK: - Swipe Actions
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            if status.status == .open {
                Button {
                    onDone()
                } label: {
                    Label("Done", systemImage: "checkmark")
                }
                .tint(.white)
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            if status.status == .open {

                if let onSnooze {
                    Button {
                        onSnooze()
                    } label: {
                        Label("Snooze", systemImage: "clock")
                    }
                    .tint(.gray)
                }

                if let onSkip {
                    Button {
                        onSkip()
                    } label: {
                        Label("Skip", systemImage: "forward.end")
                    }
                    .tint(.red)
                }
            }
        }
    }

    // MARK: - Status Indicator

    private var statusIndicator: some View {
        ZStack {
            Circle()
                .strokeBorder(indicatorStrokeColor, lineWidth: 1.5)
                .frame(width: 22, height: 22)

            if status.status == .done {
                Circle()
                    .fill(Color.white)
                    .frame(width: 12, height: 12)
                    .transition(.scale)
            }
        }
    }

    // MARK: - Styling

    private var rowBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(backgroundColor)
    }

    private var backgroundColor: Color {
        switch status.status {
        case .done:
            return Color.white.opacity(0.04)
        case .open:
            return status.isOverdue
                ? Color.red.opacity(0.12)
                : Color.white.opacity(0.09)
        case .missed:
            return Color.white.opacity(0.05)
        }
    }

    private var indicatorStrokeColor: Color {
        switch status.status {
        case .done:
            return .white
        case .open:
            return status.isOverdue ? .red : Color.white.opacity(0.5)
        case .missed:
            return Color.white.opacity(0.3)
        }
    }

    private var titleColor: Color {
        switch status.status {
        case .done:
            return .gray
        case .open:
            return .white
        case .missed:
            return Color.white.opacity(0.5)
        }
    }

    // MARK: - Subtitle

    private var subtitleText: String? {
        if status.isOverdue {
            return "Overdue"
        }

        guard
            item.type == .supplement,
            let unit = item.unit,
            let amount = item.amount
        else {
            return nil
        }

        let formattedAmount: String =
            amount.truncatingRemainder(dividingBy: 1) == 0
            ? String(Int(amount))
            : String(format: "%.1f", amount)

        return "\(formattedAmount) \(unit.displayName)"
    }
}
