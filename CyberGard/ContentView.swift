import SwiftUI

struct ContentView: View {
  @Environment(\.emailReportService) private var emailReportService

  @StateObject private var viewModel: TabNavigationViewModel = .init()

  var body: some View {
    TabView(selection: $viewModel.selectedTab) {
      HomePage()
        .tabItem {
          Label(AppTab.home.title, systemImage: "house")
        }
        .tag(AppTab.home)

      EmailLookupPage(service: emailReportService)
        .tabItem {
          Label(AppTab.emailLookup.title, systemImage: "envelope")
        }
        .tag(AppTab.emailLookup)

      PhoneLookupPage()
        .tabItem {
          Label(AppTab.phoneLookup.title, systemImage: "phone")
        }
        .tag(AppTab.phoneLookup)

      UrlLookupPage()
        .tabItem {
          Label(AppTab.urlLookup.title, systemImage: "link")
        }
        .tag(AppTab.urlLookup)

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
    .environment(\.emailReportService, EmailReportInMemoryService())
}
