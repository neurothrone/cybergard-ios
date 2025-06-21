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

      EmailScreen()
        .tabItem {
          Label(ScreenTab.email.title, systemImage: "envelope")
        }
        .tag(ScreenTab.email)
    }
  }
}

#Preview {
  ContentView()
    .environment(\.emailReportService, EmailReportInMemoryService())
}
