import Foundation

enum AppTab: Identifiable, CaseIterable {
  case home
  case emailLookup
  case phoneLookup
  case urlLookup
  case settings

  var id: Self { self }

  var title: String {
    switch self {
    case .home:
      return "Home"
    case .emailLookup:
      return "Email"
    case .phoneLookup:
      return "Phone"
    case .urlLookup:
      return "URL"
    case .settings:
      return "Settings"
    }
  }
}
