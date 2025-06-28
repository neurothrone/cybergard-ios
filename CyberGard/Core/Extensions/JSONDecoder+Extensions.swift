import Foundation

extension JSONDecoder {
  static func decodeWithFlexibleISO8601<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .flexibleISO8601
    return try decoder.decode(T.self, from: data)
  }
}

extension JSONDecoder.DateDecodingStrategy {
  static let flexibleISO8601: JSONDecoder.DateDecodingStrategy = .custom { decoder in
    let container = try decoder.singleValueContainer()
    let dateStr = try container.decode(String.self)
    let formats = [
      "yyyy-MM-dd'T'HH:mm:ss.SSSZ",  // with milliseconds
      "yyyy-MM-dd'T'HH:mm:ssZ",  // without milliseconds
    ]
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    for format in formats {
      formatter.dateFormat = format
      if let date = formatter.date(from: dateStr) {
        return date
      }
    }
    throw DecodingError.dataCorruptedError(
      in: container,
      debugDescription: "Invalid date: \(dateStr)"
    )
  }
}
