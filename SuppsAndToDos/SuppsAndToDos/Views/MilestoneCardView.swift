import SwiftUI

struct MilestoneCardView: View {

    let milestone: Milestone

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            Text(milestone.title.uppercased())
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.gray)

            Text(milestone.subtitle)
                .font(.system(size: 17, weight: .medium))

            ProgressView(
                value: Double(milestone.currentCount),
                total: Double(milestone.targetCount)
            )
            .progressViewStyle(.linear)
            .tint(.white)

            Text("\(milestone.currentCount) / \(milestone.targetCount)")
                .font(.system(size: 11))
                .foregroundColor(.gray)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.06))
        )
    }
}
