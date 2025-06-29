import Foundation

struct UrlValidator {
  static func isValidUrl(_ urlString: String) -> Bool {
    guard let components = URLComponents(string: urlString),
      let scheme = components.scheme?.lowercased(),
      ["http", "https", "ftp"].contains(scheme),
      let host = components.host,
      !host.isEmpty
    else {
      return false
    }

    return true
  }
}
