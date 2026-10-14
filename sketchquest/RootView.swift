import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem { Label("Home", systemImage: "house.fill") }

            NavigationStack {
                HistoryView()
            }
            .tabItem { Label("History", systemImage: "clock.arrow.circlepath") }

            NavigationStack {
                StatisticsView()
            }
            .tabItem { Label("Progress", systemImage: "chart.bar.fill") }
        }
        .tint(SketchTheme.blue)
    }
}
