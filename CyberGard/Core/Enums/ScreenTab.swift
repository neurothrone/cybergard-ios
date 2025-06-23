import Foundation

enum ScreenTab: Identifiable, CaseIterable {
  case home
  case email

  var id: Self { self }

  var title: String {
    switch self {
    case .home:
      return "Home"
    case .email:
      return "Email"
    }
  }
}
