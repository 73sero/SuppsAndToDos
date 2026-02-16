import SwiftUI

struct MilestonesView: View {

    @EnvironmentObject private var viewModel: TodayViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {

                // MARK: - HEADER
                VStack(alignment: .leading, spacing: 6) {
                    Text("MILESTONES")
                        .font(.system(size: 26, weight: .bold))

                    Text("Your long-term progress")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
                .padding(.top, 12)

                // MARK: - ACTIVE MILESTONE
                if let active = activeMilestone {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("ACTIVE")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.gray)

                        MilestoneCardView(milestone: active)
                    }
                }

                // MARK: - ALL MILESTONES
                VStack(alignment: .leading, spacing: 12) {

                    Text("ALL MILESTONES")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.gray)

                    VStack(spacing: 14) {
                        ForEach(viewModel.milestones) { milestone in
                            MilestoneCardView(milestone: milestone)
                                .opacity(milestone.isCompleted ? 0.5 : 1.0)
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color.black)
        .foregroundColor(.white)
    }

    // MARK: - HELPERS

    private var activeMilestone: Milestone? {
        viewModel.milestones.first {
            !$0.isCompleted &&
            (
                $0.relatedItemType == nil ||
                $0.relatedItemType?.matches(viewModel.selectedCategory) == true
            )
        }
    }
}

#Preview {
    let vm = TodayViewModel(reminderStore: .shared)
    vm.load(
        items: MockData.items,
        schedules: MockData.schedules,
        statuses: MockData.statuses,
        settings: SettingsViewModel()
    )

    return MilestonesView()
        .environmentObject(vm)
        .preferredColorScheme(.dark)
}
