import Foundation

struct Comment: Codable {
  var text: String
  var postedDate: Date

  enum CodingKeys: String, CodingKey {
    case text
    case postedDate = "posted-date"
  }
}

extension Comment {
  static var sample: Comment {
    Comment(
      text: "This looks suspicious.",
      postedDate: .now
    )
  }
}
