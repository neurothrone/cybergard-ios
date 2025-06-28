import Foundation

struct UrlReportDetails: Identifiable, Decodable {
  var url: String
  var scamType: String
  var country: String
  var reportedDate: Date
  var comments: [Comment]

  var id: String { url }

  var commentsCount: Int { comments.count }

  enum CodingKeys: String, CodingKey {
    case url = "url"
    case scamType = "scam-type"
    case country
    case reportedDate = "reported-date"
    case comments
  }
}

extension UrlReportDetails {
  /// Loads sample email reports from a JSON file in the app bundle.
  /// - Parameter filename: The name of the JSON file (without extension). Defaults to "url-sample-data".
  /// - Returns: An array of `UrlReportDetails` decoded from the JSON, or an empty array on failure.
  static func loadSampleReports(
    from filename: String = "url-sample-data"
  ) -> [UrlReportDetails] {
    guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
      print("❌ Failed to locate \(filename).json in bundle.")
      return []
    }
    do {
      let data = try Data(contentsOf: url)
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601
      return try decoder.decode([UrlReportDetails].self, from: data)
    } catch {
      print("❌ Failed to decode \(filename).json: \(error)")
      return []
    }
  }
}

extension UrlReportDetails {
  static var sample: UrlReportDetails {
    UrlReportDetails(
      url: "http://www.scam.com",
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

  static var samples: [UrlReportDetails] {
    [.sample]
      + (1...23).map { index in
        let comments = (1...index).map { cIndex in
          Comment(
            text: "Comment #\(cIndex) for user\(index)",
            postedDate: Calendar.current.date(byAdding: .hour, value: -cIndex, to: .now) ?? .now
          )
        }
        return UrlReportDetails(
          url: "http://www.scam\(index).com",
          scamType: index % 2 == 0 ? "Phishing" : "Malware",
          country: index % 2 == 0 ? "SE" : "DE",
          reportedDate: Calendar.current.date(byAdding: .day, value: -index, to: .now) ?? .now,
          comments: comments
        )
      }
  }
}
