import Foundation

enum ApiEnvironment {
  case development
  case staging
  case production

  var baseURL: URL {
    switch self {
    case .development:
      return URL(string: "http://localhost:5001/api/v2")!
    case .staging:
      return URL(string: "https://staging.example.com/api/v2")!
    case .production:
      return URL(string: "https://api.example.com/api/v2")!
    }
  }
}
