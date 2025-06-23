import Foundation

struct EmailReportDetails: Identifiable, Codable  {
  var email: String
  var scamType: String
  var country: String
  var reportedDate: Date
  var comments: [Comment]
  
  var id: String { email }

  enum CodingKeys: String, CodingKey {
    case email
    case scamType = "scam-type"
    case country
    case reportedDate = "reported-date"
    case comments
  }
}

extension EmailReportDetails {
  static var sample: EmailReportDetails {
    EmailReportDetails(
      email: "john.doe@example.com",
      scamType: "Phishing",
      country: "US",
      reportedDate: .now,
      comments: [
        Comment(
          text: "This looks suspicious.",
          postedDate: .now
        )
      ]
    )
  }

  static var samples: [EmailReportDetails] {
    (1...5).map { index in
      let comment = Comment(
        text: "Comment #\(index)",
        postedDate: Date().addingTimeInterval(-Double(index) * 3600)
      )

      return EmailReportDetails(
        email: "user\(index)@example.com",
        scamType: index % 2 == 0 ? "Phishing" : "Malware",
        country: index % 2 == 0 ? "SE" : "DE",
        reportedDate: Date().addingTimeInterval(-Double(index) * 86400),
        comments: [comment]
      )
    }
  }
}
