import Foundation

struct UrlReportResponse: Decodable {
  let results: [UrlReport]
  let total: Int
}
