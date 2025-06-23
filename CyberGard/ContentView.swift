import SwiftUI

struct ContentView: View {
  @Environment(\.emailReportService) private var emailReportService

  @State private var selectedTab: ScreenTab = .home

  var body: some View {
    TabView(selection: $selectedTab) {
      HomeScreen()
        .tabItem {
          Label(ScreenTab.home.title, systemImage: "house")
        }
        .tag(ScreenTab.home)

      EmailLookupPage(service: emailReportService)
        .tabItem {
          Label(ScreenTab.emailLookup.title, systemImage: "envelope")
        }
        .tag(ScreenTab.emailLookup)
      
      PhoneLookupScreen()
        .tabItem {
          Label(ScreenTab.phoneLookup.title, systemImage: "phone")
        }
        .tag(ScreenTab.phoneLookup)
      
      UrlLookupScreen()
        .tabItem {
          Label(ScreenTab.urlLookup.title, systemImage: "link")
        }
        .tag(ScreenTab.urlLookup)
      
      SettingsScreen()
        .tabItem {
          Label(ScreenTab.settings.title, systemImage: "gear")
        }
        .tag(ScreenTab.settings)
    }
  }
}

#Preview {
  ContentView()
    .environment(\.emailReportService, EmailReportInMemoryService())
}
