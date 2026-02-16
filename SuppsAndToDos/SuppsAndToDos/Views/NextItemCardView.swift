import SwiftUI

struct NextItemCardView: View {

    let item: Item
    let status: ItemStatus
    let onDone: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack {
                Text("NEXT")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.gray)

                Spacer()
            }

            HStack(spacing: 12) {

                Circle()
                    .stroke(Color.white.opacity(0.4), lineWidth: 1)
                    .frame(width: 22, height: 22)
                    .onTapGesture {
                        onDone()
                    }

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.system(size: 18, weight: .semibold))

                    if let dosage = dosageText {
                        Text(dosage)
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                    }
                }

                Spacer()
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.08))
        )
    }

    private var dosageText: String? {
        guard
            item.type == .supplement,
            let unit = item.unit,
            let amount = item.amount
        else { return nil }

        let formatted =
            amount.truncatingRemainder(dividingBy: 1) == 0
            ? String(Int(amount))
            : String(format: "%.1f", amount)

        return "\(formatted) \(unit.displayName)"
    }
}
