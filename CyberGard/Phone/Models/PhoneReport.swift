import Foundation

struct PhoneReport: Identifiable, Equatable, Decodable {
  var phoneNumber: String
  var scamType: String
  var country: String
  var reportedDate: Date
  var commentsCount: Int

  var id: String { phoneNumber }

  enum CodingKeys: String, CodingKey {
    case phoneNumber = "phone-number"
    case scamType = "scam-type"
    case country
    case reportedDate = "reported-date"
    case commentsCount = "comments-count"
  }
}

extension PhoneReport {
  static func from(details: PhoneReportDetails) -> PhoneReport {
    PhoneReport(
      phoneNumber: details.phoneNumber,
      scamType: details.scamType,
      country: details.country,
      reportedDate: details.reportedDate,
      commentsCount: details.comments.count
    )
  }
}

extension PhoneReport {
  static var sample: PhoneReport {
    PhoneReport(
      phoneNumber: "+1234567890",
      scamType: "Phishing",
      country: "US",
      reportedDate: .now,
      commentsCount: 5
    )
  }

  static var samples: [PhoneReport] {
    [sample]
      + (1...5).compactMap { index in
        let phoneNumber = "+123456789\(index)"
        let scamType = index.isMultiple(of: 2) ? "Phishing" : "Malware"
        let country = index.isMultiple(of: 2) ? "SE" : "DE"
        let reportedDate = Calendar.current.date(byAdding: .day, value: -index, to: .now) ?? .now
        let commentsCount = Int.random(in: 1...6)

        return PhoneReport(
          phoneNumber: phoneNumber,
          scamType: scamType,
          country: country,
          reportedDate: reportedDate,
          commentsCount: commentsCount
        )
      }
  }
}
