import Foundation

struct ReportItem: Decodable, Identifiable, Equatable {
  let reportType: ReportType
  let identifier: String
  let scamType: ScamType
  let country: String
  let reportedDate: Date
  let commentsCount: Int

  var id: String { identifier }

  enum CodingKeys: String, CodingKey {
    case reportType = "report-type"
    case identifier
    case scamType = "scam-type"
    case country
    case reportedDate = "reported-date"
    case commentsCount = "comments-count"
  }
}
