import Foundation

struct EmailReportDetails: Identifiable, Codable {
  var email: String
  var scamType: String
  var country: String
  var reportedDate: Date
  var comments: [Comment]

  var id: String { email }
  
  var commentsCount: Int { comments.count }

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
    [.sample]
      + (1...5).map { index in
        let comments = (1...index).map { cIndex in
          Comment(
            text: "Comment #\(cIndex) for user\(index)",
            postedDate: Calendar.current.date(byAdding: .hour, value: -cIndex, to: .now) ?? .now
          )
        }
        return EmailReportDetails(
          email: "user\(index)@example.com",
          scamType: index % 2 == 0 ? "Phishing" : "Malware",
          country: index % 2 == 0 ? "SE" : "DE",
          reportedDate: Calendar.current.date(byAdding: .day, value: -index, to: .now) ?? .now,
          comments: comments
        )
      }
  }
}
