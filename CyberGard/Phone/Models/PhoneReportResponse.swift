import Foundation

struct PhoneReportResponse: Decodable {
  let results: [PhoneReport]
  let total: Int
}
