import Foundation

struct EmailReportResponse: Decodable {
  let results: [EmailReport]
  let total: Int
}
