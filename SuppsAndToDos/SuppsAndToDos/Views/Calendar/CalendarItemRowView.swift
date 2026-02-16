import SwiftUI

struct CalendarItemRowView: View {

    let item: Item
    let status: ItemStatus

    var body: some View {
        HStack(spacing: 12) {

            statusIndicator

            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(titleColor)

                if let subtitle = subtitleText {
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }

            Spacer()

            Text(statusText)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(statusColor)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(backgroundOpacity))
        )
    }

    // MARK: - Visuals

    private var statusIndicator: some View {
        Circle()
            .fill(indicatorColor)
            .frame(width: 8, height: 8)
    }

    private var titleColor: Color {
        status.status == .done ? .gray : .white
    }

    private var backgroundOpacity: Double {
        switch status.status {
        case .done:   return 0.04
        case .missed: return 0.08
        case .open:   return 0.06
        }
    }

    private var indicatorColor: Color {
        switch status.status {
        case .done:   return .white
        case .missed: return .red.opacity(0.85)
        case .open:   return .gray
        }
    }

    private var statusColor: Color {
        switch status.status {
        case .done:   return .gray
        case .missed: return .red.opacity(0.9)
        case .open:   return .gray
        }
    }

    private var statusText: String {
        switch status.status {
        case .done:   return "DONE"
        case .missed: return "MISSED"
        case .open:   return "OPEN"
        }
    }

    private var subtitleText: String? {
        guard
            item.type == .supplement,
            let unit = item.unit,
            let amount = item.amount
        else { return nil }

        let value =
            amount.truncatingRemainder(dividingBy: 1) == 0
            ? String(Int(amount))
            : String(format: "%.1f", amount)

        return "\(value) \(unit.displayName)"
    }
}
