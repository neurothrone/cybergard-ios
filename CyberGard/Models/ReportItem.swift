import Foundation

struct ReportItem: Codable {
  var comment: String
  var date: Date

  enum CodingKeys: String, CodingKey {
    case comment
    case date
  }
}

extension ReportItem {
  static var sample: ReportItem {
    ReportItem(
      comment: "This looks suspicious.",
      date: .now
    )
  }
}
