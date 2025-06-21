import Foundation

struct EmailReport: Identifiable, Codable  {
  var email: String
  var scamType: String
  var country: String
  var reportedDate: Date
  var reports: [ReportItem]
  
  var id: String { email }

  enum CodingKeys: String, CodingKey {
    case email
    case scamType = "scam-type"
    case country
    case reportedDate = "reported-date"
    case reports
  }
}

extension EmailReport {
  static var sample: EmailReport {
    EmailReport(
      email: "john.doe@example.com",
      scamType: "Phishing",
      country: "US",
      reportedDate: Date(),
      reports: [
        ReportItem(
          comment: "This looks suspicious.",
          date: Date()
        )
      ]
    )
  }

  static var samples: [EmailReport] {
    (1...5).map { index in
      let reportItem = ReportItem(
        comment: "Report #\(index)",
        date: Date().addingTimeInterval(-Double(index) * 3600)
      )

      return EmailReport(
        email: "user\(index)@example.com",
        scamType: index % 2 == 0 ? "Phishing" : "Malware",
        country: index % 2 == 0 ? "SE" : "DE",
        reportedDate: Date().addingTimeInterval(-Double(index) * 86400),
        reports: [reportItem]
      )
    }
  }
}
