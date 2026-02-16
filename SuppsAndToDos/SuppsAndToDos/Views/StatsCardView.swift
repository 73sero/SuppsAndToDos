import SwiftUI

struct StatsCardView: View {

    let title: String
    let stats: PeriodStatistics?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            Text(title.uppercased())
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.gray)

            Text(percentageText)
                .font(.system(size: 20, weight: .bold))

            ProgressView(value: completionRate)
                .progressViewStyle(.linear)
                .tint(.white)

            Text(detailText)
                .font(.system(size: 11))
                .foregroundColor(.gray)
        }
        .padding(14)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.06))
        )
    }

    private var completionRate: Double {
        stats?.completionRate ?? 0.0
    }

    private var percentageText: String {
        "\(Int(completionRate * 100))%"
    }

    private var detailText: String {
        guard let stats else { return "No data" }
        return "\(stats.done) / \(stats.total)"
    }
}
