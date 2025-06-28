import Foundation

struct ReportDetails: Decodable, Identifiable {
  let reportType: ReportType
  let identifier: String
  let scamType: ScamType
  let country: String
  let reportedDate: Date
  var comments: [Comment]

  var id: String { identifier }

  enum CodingKeys: String, CodingKey {
    case reportType = "report-type"
    case identifier
    case scamType = "scam-type"
    case country
    case reportedDate = "reported-date"
    case comments
  }
}
