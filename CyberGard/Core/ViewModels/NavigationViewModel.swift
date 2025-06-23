import Foundation

final class NavigationViewModel: ObservableObject {
  @Published var selectedTab: AppTab = .home

  func selectTab(_ tab: AppTab) {
    selectedTab = tab
  }

  func isTabSelected(_ tab: AppTab) -> Bool {
    selectedTab == tab
  }

  func resetToHome() {
    selectedTab = .home
  }
}
