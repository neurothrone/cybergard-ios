import Foundation

struct ReportItem: Codable {
  var comment: String
  var date: Date

  enum CodingKeys: String, CodingKey {
    case comment
    case date
  }
}
