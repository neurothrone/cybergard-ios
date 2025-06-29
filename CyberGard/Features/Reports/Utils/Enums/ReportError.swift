import Foundation

enum ReportError: Error {
  case badRequest(message: String)
  case notFound
  case serverError
  case createFailed
  case updateFailed
  case deleteFailed
  case decodingFailed
  case invalidURL
}
