import Foundation

struct UrlValidator {
  static func isValidUrl(_ url: String) -> Bool {
    guard let url = URL(string: url) else { return false }
    return ["http", "https", "ftp"].contains(url.scheme?.lowercased() ?? "")
  }
}
