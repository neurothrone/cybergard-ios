import Foundation

struct UrlReport: Identifiable, Equatable, Decodable {
  var url: String
  var scamType: String
  var country: String
  var reportedDate: Date
  var commentsCount: Int

  var id: String { url }

  enum CodingKeys: String, CodingKey {
    case url = "url"
    case scamType = "scam-type"
    case country
    case reportedDate = "reported-date"
    case commentsCount = "comments-count"
  }
}

extension UrlReport {
  static func from(details: UrlReportDetails) -> UrlReport {
    UrlReport(
      url: details.url,
      scamType: details.scamType,
      country: details.country,
      reportedDate: details.reportedDate,
      commentsCount: details.comments.count
    )
  }
}

extension UrlReport {
  static var sample: UrlReport {
    UrlReport(
      url: "http://www.scam.com",
      scamType: "Phishing",
      country: "US",
      reportedDate: .now,
      commentsCount: 5
    )
  }

  static var samples: [UrlReport] {
    [sample]
      + (1...5).compactMap { index in
        let url = "http://www.scam\(index).com"
        let scamType = index.isMultiple(of: 2) ? "Phishing" : "Malware"
        let country = index.isMultiple(of: 2) ? "SE" : "DE"
        let reportedDate = Calendar.current.date(byAdding: .day, value: -index, to: .now) ?? .now
        let commentsCount = Int.random(in: 1...6)

        return UrlReport(
          url: url,
          scamType: scamType,
          country: country,
          reportedDate: reportedDate,
          commentsCount: commentsCount
        )
      }
  }
}
