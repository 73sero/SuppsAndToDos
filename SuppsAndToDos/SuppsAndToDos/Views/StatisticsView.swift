import SwiftUI

struct StatisticsView: View {

    let title: String
    let stats: PeriodStatistics

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text(title.uppercased())
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.gray)

            HStack(spacing: 16) {

                statBlock(
                    value: stats.done,
                    label: "Done"
                )

                statBlock(
                    value: stats.missed,
                    label: "Missed"
                )

                statBlock(
                    value: stats.total,
                    label: "Total"
                )
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.06))
        )
    }
    


    private func statBlock(value: Int, label: String) -> some View {
        VStack(spacing: 4) {

            Text("\(value)")
                .font(.system(size: 18, weight: .bold))

            Text(label)
                .font(.system(size: 11))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}
