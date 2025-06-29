import Foundation

struct ReportItem: Decodable, Identifiable, Equatable {
  let reportType: ReportType
  let identifier: String
  let scamType: ScamType
  let country: String
  let reportedDate: Date
  var commentsCount: Int

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

extension ReportItem {
  static func from(details: ReportDetails) -> ReportItem {
    ReportItem(
      reportType: details.reportType,
      identifier: details.identifier,
      scamType: details.scamType,
      country: details.country,
      reportedDate: details.reportedDate,
      commentsCount: details.comments.count
    )
  }
}

extension ReportItem {
  static var sample: ReportItem {
    ReportItem(
      reportType: .email,
      identifier: "john.doe@example.com",
      scamType: .phishing,
      country: "US",
      reportedDate: Calendar.current.date(byAdding: .day, value: -1, to: .now) ?? .now,
      commentsCount: 5
    )
  }

  static var samples: [ReportItem] {
    [sample]
      + (1...5).compactMap { index in
        let email = "user\(index)@example.com"
        let scamType: ScamType = index.isMultiple(of: 2) ? .phishing : .maliciousContent
        let country = index.isMultiple(of: 2) ? "SE" : "DE"
        let reportedDate = Calendar.current.date(byAdding: .day, value: -index, to: .now) ?? .now
        let commentsCount = Int.random(in: 1...6)

        return ReportItem(
          reportType: .email,
          identifier: email,
          scamType: scamType,
          country: country,
          reportedDate: reportedDate,
          commentsCount: commentsCount
        )
      }
  }
}
