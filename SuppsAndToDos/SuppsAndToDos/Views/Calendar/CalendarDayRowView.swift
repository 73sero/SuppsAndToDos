import SwiftUI

struct CalendarDayRowView: View {

    let day: CalendarDay
    let supplementCount: Int
    let todoCount: Int
    let notePreview: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            // MARK: - Top Row (Date + Counters)
            HStack {

                VStack(alignment: .leading, spacing: 4) {
                    Text(day.date, style: .date)
                        .font(.system(size: 16, weight: .medium))

                    HStack(spacing: 8) {
                        if supplementCount > 0 {
                            Text("💊 \(supplementCount)")
                        }
                        if todoCount > 0 {
                            Text("📝 \(todoCount)")
                        }
                    }
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                }

                Spacer()

                if day.isPerfectDay {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                }
            }

            // MARK: - Note Preview (2 Lines + Fade)
            if let notePreview {
                Text(notePreview)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .overlay(
                        LinearGradient(
                            colors: [
                                Color.clear,
                                Color.black.opacity(0.6)
                            ],
                            startPoint: .center,
                            endPoint: .bottom
                        )
                        .allowsHitTesting(false)
                    )
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.06))
        )
    }
}
