import Foundation

final class ReportApiService: ReportHandling {
  private let baseURL: URL

  init(baseURL: URL) {
    self.baseURL = baseURL
  }

  private func resourcePath(for type: ReportType) -> String {
    switch type {
    case .email: "email-reports"
    case .phone: "phone-reports"
    case .url: "url-reports"
    }
  }

  private func identifierKey(for type: ReportType) -> String {
    switch type {
    case .email: "email"
    case .phone: "phone-number"
    case .url: "url"
    }
  }

  func searchReports(
    page: Int = 1,
    pageSize: Int = 10,
    query: String? = nil
  ) async throws -> SearchReportResponse {
    var queryItems: [URLQueryItem] = [
      URLQueryItem(name: "page", value: "\(page)"),
      URLQueryItem(name: "pageSize", value: "\(pageSize)"),
    ]
    if let query = query, !query.isEmpty {
      queryItems.append(URLQueryItem(name: "query", value: query))
    }
    let apiUrl =
      baseURL
      //      .appendingPathComponent(resourcePath(for: type))
      .appendingPathComponent("reports")
      .appending(queryItems: queryItems)

    let (data, response) = try await URLSession.shared.data(from: apiUrl)
    guard let httpResponse = response as? HTTPURLResponse,
      200..<300 ~= httpResponse.statusCode
    else {
      throw ReportError.serverError
    }
    do {
      return try JSONDecoder.decodeWithFlexibleISO8601(SearchReportResponse.self, from: data)
    } catch {
      throw ReportError.decodingFailed
    }
  }

  func getBy(
    type: ReportType,
    identifier: String
  ) async throws -> ReportDetails? {
    let apiUrl: URL
    if type == .url {
      apiUrl =
        baseURL
        .appendingPathComponent(resourcePath(for: type))
        .appending(queryItems: [URLQueryItem(name: "url", value: identifier)])
    } else {
      apiUrl = baseURL.appendingPathComponent("\(resourcePath(for: type))/\(identifier)")
    }
    let (data, response) = try await URLSession.shared.data(from: apiUrl)
    guard let httpResponse = response as? HTTPURLResponse else {
      throw ReportError.serverError
    }
    switch httpResponse.statusCode {
    case 200:
      return try JSONDecoder.decodeWithFlexibleISO8601(ReportDetails.self, from: data)
    case 404:
      return nil
    default:
      throw ReportError.serverError
    }
  }

  func createReport(
    type: ReportType,
    identifier: String,
    scamType: String,
    country: String,
    comment: String
  ) async throws -> ReportDetails {
    let apiUrl = baseURL.appendingPathComponent(resourcePath(for: type))
    var request = URLRequest(url: apiUrl)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let body: [String: String] = [
      identifierKey(for: type): identifier,
      "scam-type": scamType,
      "country": country,
      "comment": comment,
    ]
    request.httpBody = try JSONEncoder().encode(body)

    let (data, response) = try await URLSession.shared.data(for: request)
    guard let httpResponse = response as? HTTPURLResponse else {
      throw ReportError.serverError
    }
    switch httpResponse.statusCode {
    case 200, 201:
      break
    default:
      throw ReportError.createFailed
    }
    return try JSONDecoder.decodeWithFlexibleISO8601(ReportDetails.self, from: data)
  }

  func addCommentToReport(
    type: ReportType,
    identifier: String,
    comment: String
  ) async throws -> ReportDetails? {
    let apiUrl = baseURL.appendingPathComponent("\(resourcePath(for: type))/\(identifier)/comments")
    var request = URLRequest(url: apiUrl)
    request.httpMethod = "PUT"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let body = ["comment": comment]
    request.httpBody = try JSONEncoder().encode(body)

    let (data, response) = try await URLSession.shared.data(for: request)
    guard let httpResponse = response as? HTTPURLResponse else {
      throw ReportError.serverError
    }
    switch httpResponse.statusCode {
    case 200:
      return try JSONDecoder.decodeWithFlexibleISO8601(ReportDetails.self, from: data)
    case 404:
      return nil
    default:
      throw ReportError.updateFailed
    }
  }

  func deleteReportBy(
    type: ReportType,
    identifier: String
  ) async throws -> Bool {
    let apiUrl = baseURL.appendingPathComponent("\(resourcePath(for: type))/\(identifier)")
    var request = URLRequest(url: apiUrl)
    request.httpMethod = "DELETE"

    let (_, response) = try await URLSession.shared.data(for: request)
    guard let httpResponse = response as? HTTPURLResponse else {
      throw ReportError.serverError
    }
    switch httpResponse.statusCode {
    case 204:
      return true
    case 404:
      return false
    default:
      throw ReportError.deleteFailed
    }
  }
}
