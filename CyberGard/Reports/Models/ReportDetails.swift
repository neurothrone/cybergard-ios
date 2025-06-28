import Foundation

struct ReportDetails: Decodable, Identifiable {
  let reportType: ReportType
  let identifier: String
  let scamType: ScamType
  let country: String
  let reportedDate: Date
  var comments: [Comment]

  var id: String { identifier }

  enum CodingKeys: String, CodingKey {
    case reportType = "report-type"
    case identifier
    case scamType = "scam-type"
    case country
    case reportedDate = "reported-date"
    case comments
  }
}

extension ReportDetails {
  /// Loads sample email reports from a JSON file in the app bundle.
  /// - Parameter filename: The name of the JSON file (without extension). Defaults to "email-sample-data".
  /// - Returns: An array of `ReportDetails` decoded from the JSON, or an empty array on failure.
  static func loadSampleReports(
    from filename: String = "email-sample-data"
  ) -> [ReportDetails] {
    guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
      print("❌ Failed to locate \(filename).json in bundle.")
      return []
    }
    do {
      let data = try Data(contentsOf: url)
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601
      return try decoder.decode([ReportDetails].self, from: data)
    } catch {
      print("❌ Failed to decode \(filename).json: \(error)")
      return []
    }
  }
}

extension ReportDetails {
  static var sample: ReportDetails {
    ReportDetails(
      reportType: .email,
      identifier: "john.doe@example.com",
      scamType: .phishing,
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

  static var samples: [ReportDetails] {
    [.sample]
      + (1...23).map { index in
        let comments = (1...index).map { cIndex in
          Comment(
            text: "Comment #\(cIndex) for user\(index)",
            postedDate: Calendar.current.date(byAdding: .hour, value: -cIndex, to: .now) ?? .now
          )
        }
        return ReportDetails(
          reportType: .email,
          identifier: "user\(index)@example.com",
          scamType: index % 2 == 0 ? .phishing : .maliciousContent,
          country: index % 2 == 0 ? "SE" : "DE",
          reportedDate: Calendar.current.date(byAdding: .day, value: -index, to: .now) ?? .now,
          comments: comments
        )
      }
  }
}
