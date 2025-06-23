import Foundation

struct EmailReport: Identifiable, Decodable  {
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
    (1...5).compactMap { index in
      let email = "user\(index)@example.com"
      let scamType = index.isMultiple(of: 2) ? "Phishing" : "Malware"
      let country = index.isMultiple(of: 2) ? "SE" : "DE"
      let date = Calendar.current.date(byAdding: .day, value: -index, to: .now)
      let comments = index * 2

      guard let reportedDate = date else { return nil }

      return EmailReport(
        email: email,
        scamType: scamType,
        country: country,
        reportedDate: reportedDate,
        commentsCount: comments
      )
    }
  }
}
