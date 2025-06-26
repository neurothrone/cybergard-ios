import SwiftUI

struct ContentView: View {
  @Environment(\.emailReportService) private var emailReportService
  @Environment(\.phoneReportService) private var phoneReportService
  @Environment(\.urlReportService) private var urlReportService

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

      PhoneLookupPage(service: phoneReportService)
        .tabItem {
          Label(AppTab.phoneLookup.title, systemImage: "phone")
        }
        .tag(AppTab.phoneLookup)

      UrlLookupPage(service: urlReportService)
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
    .environment(\.phoneReportService, PhoneReportInMemoryService())
    .environment(\.urlReportService, UrlReportInMemoryService())
}
