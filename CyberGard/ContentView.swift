import SwiftUI

struct ContentView: View {
  @Environment(\.reportService) private var reportService: ReportHandling

  @StateObject private var viewModel: TabNavigationViewModel = .init()

  var body: some View {
    TabView(selection: $viewModel.selectedTab) {
      HomePage()
        .tabItem {
          Label(AppTab.home.title, systemImage: "house")
        }
        .tag(AppTab.home)

      ReportLookupPage(service: reportService)
        .tabItem {
          Label(AppTab.reports.title, systemImage: "magnifyingglass")
        }
        .tag(AppTab.reports)

      SettingsPage()
        .tabItem {
          Label(AppTab.settings.title, systemImage: "gear")
        }
        .tag(AppTab.settings)
    }
  }
}

#Preview {
  ContentView()
    .environment(
      \.reportService,
      ReportPreviewService(
        initialReports: ReportDetails.loadSampleReports()
      )
    )
}
