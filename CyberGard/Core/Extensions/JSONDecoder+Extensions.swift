import Foundation

extension JSONDecoder {
  static func decodeWithFlexibleISO8601<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .flexibleISO8601
    return try decoder.decode(T.self, from: data)
  }
}
