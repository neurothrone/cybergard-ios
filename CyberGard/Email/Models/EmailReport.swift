import Foundation

struct EmailReport: Identifiable, Decodable {
  var email: String
  var scamType: String
  var country: String
  var reportedDate: Date
  var commentsCount: Int

  var id: String { email }

  enum CodingKeys: String, CodingKey {
    case email
    case scamType = "scam-type"
    case country
    case reportedDate = "reported-date"
    case commentsCount = "comments-count"
  }
}

extension EmailReport {
  static func from(details: EmailReportDetails) -> EmailReport {
    EmailReport(
      email: details.email,
      scamType: details.scamType,
      country: details.country,
      reportedDate: details.reportedDate,
      commentsCount: details.comments.count
    )
  }
}

extension EmailReport {
  static var sample: EmailReport {
    EmailReport(
      email: "john.doe@example.com",
      scamType: "Phishing",
      country: "US",
      reportedDate: .now,
      commentsCount: 5
    )
  }

  static var samples: [EmailReport] {
    [sample]
      + (1...5).compactMap { index in
        let email = "user\(index)@example.com"
        let scamType = index.isMultiple(of: 2) ? "Phishing" : "Malware"
        let country = index.isMultiple(of: 2) ? "SE" : "DE"
        let reportedDate = Calendar.current.date(byAdding: .day, value: -index, to: .now) ?? .now
        let commentsCount = Int.random(in: 1...6)

        return EmailReport(
          email: email,
          scamType: scamType,
          country: country,
          reportedDate: reportedDate,
          commentsCount: commentsCount
        )
      }
  }
}
