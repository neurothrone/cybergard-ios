import Foundation

enum ScreenTab: CaseIterable, Identifiable {
  case home,
       email;
  
  var title: String {
    switch self {
    case .home:
      return "Home"
    case .email:
      return "Email"
    }
  }
  
  var id: Self { self }
}
