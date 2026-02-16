import SwiftUI

struct RootTabView: View {

    @EnvironmentObject private var todayViewModel: TodayViewModel
    @StateObject private var calendarViewModel = CalendarViewModel()

    var body: some View {
        TabView {

            TodayView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Today")
                }

            MilestonesView()
                .tabItem {
                    Image(systemName: "flag.fill")
                    Text("Milestones")
                }

            CalendarView()
                .environmentObject(calendarViewModel)
                .environmentObject(todayViewModel)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }

            SettingsPlaceholderView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
        .tint(.white)
        .background(Color.black)
        .onAppear {
            calendarViewModel.load(
                items: todayViewModel.allItems,
                statuses: todayViewModel.allStatuses,
                notes: todayViewModel.allNotes   // ✅ DayNote passt jetzt
            )
        }
    }
}
