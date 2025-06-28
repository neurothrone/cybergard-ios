import Foundation

enum AppTab: Identifiable, CaseIterable {
  case home
  case reports
  case emailLookup
  case phoneLookup
  case urlLookup
  case settings

  var id: Self { self }

  var title: String {
    switch self {
    case .home: "Home"
    case .reports: "Reports"
    case .emailLookup: "Email"
    case .phoneLookup: "Phone"
    case .urlLookup: "URL"
    case .settings: "Settings"
    }
  }
}
