import Foundation

struct PhoneReportDetails: Identifiable, Codable {
  var phoneNumber: String
  var scamType: String
  var country: String
  var reportedDate: Date
  var comments: [Comment]

  var id: String { phoneNumber }

  var commentsCount: Int { comments.count }

  enum CodingKeys: String, CodingKey {
    case phoneNumber = "phone-number"
    case scamType = "scam-type"
    case country
    case reportedDate = "reported-date"
    case comments
  }
}

extension PhoneReportDetails {
  static var sample: PhoneReportDetails {
    PhoneReportDetails(
      phoneNumber: "+1234567890",
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

  static var samples: [PhoneReportDetails] {
    [.sample]
      + (1...50).map { index in
        let comments = (1...index).map { cIndex in
          Comment(
            text: "Comment #\(cIndex) for user\(index)",
            postedDate: Calendar.current.date(byAdding: .hour, value: -cIndex, to: .now) ?? .now
          )
        }
        return PhoneReportDetails(
          phoneNumber: "+123456789\(index)",
          scamType: index % 2 == 0 ? "Phishing" : "Malware",
          country: index % 2 == 0 ? "SE" : "DE",
          reportedDate: Calendar.current.date(byAdding: .day, value: -index, to: .now) ?? .now,
          comments: comments
        )
      }
  }
}
