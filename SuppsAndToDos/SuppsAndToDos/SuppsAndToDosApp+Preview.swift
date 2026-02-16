import SwiftUI

#Preview("Full App Preview") {

    let todayVM = TodayViewModel(reminderStore: .shared)

    todayVM.load(
        items: MockData.items,
        schedules: MockData.schedules,
        statuses: MockData.statuses,
        settings: SettingsViewModel()
    )

    return RootTabView()
        .environmentObject(todayVM)
        .preferredColorScheme(.dark)
}
