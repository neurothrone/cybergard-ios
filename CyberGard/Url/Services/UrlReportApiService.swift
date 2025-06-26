import Foundation

final class UrlReportApiService: UrlReportHandling {
  private let baseURL: URL

  init(baseURL: URL = URL(string: "http://localhost:5001/api")!) {
    self.baseURL = baseURL
  }

  func searchReports(
    page: Int = 1,
    pageSize: Int = 10,
    query: String? = nil
  ) async throws -> UrlReportResponse {
    var queryItems: [URLQueryItem] = [
        URLQueryItem(name: "page", value: "\(page)"),
        URLQueryItem(name: "pageSize", value: "\(pageSize)")
    ]
    if let query = query, !query.isEmpty {
        queryItems.append(URLQueryItem(name: "query", value: query))
    }
    let apiUrl = baseURL
        .appendingPathComponent("url-reports")
        .appending(queryItems: queryItems)
    
    let (data, response) = try await URLSession.shared.data(from: apiUrl)
    
    guard let httpResponse = response as? HTTPURLResponse,
          200..<300 ~= httpResponse.statusCode else {
      throw ReportError.serverError
    }

    do {
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .formatted(.apiFormat)
      return try decoder.decode(UrlReportResponse.self, from: data)
    } catch {
      throw ReportError.decodingFailed
    }
  }
  
  func getBy(url: String) async throws -> UrlReportDetails? {
    let url = baseURL.appendingPathComponent("url-reports/\(url)")
    let (data, response) = try await URLSession.shared.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse else {
      throw ReportError.serverError
    }

    switch httpResponse.statusCode {
    case 200:
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .formatted(.apiFormat)
      return try decoder.decode(UrlReportDetails.self, from: data)
    case 404:
      return nil
    default:
      throw ReportError.serverError
    }
  }

  func createReport(
    url: String,
    scamType: String,
    country: String,
    comment: String
  ) async throws -> UrlReportDetails {
    let apiUrl = baseURL.appendingPathComponent("url-reports")
    var request = URLRequest(url: apiUrl)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let body: [String: String] = [
      "url": url,
      "scam-type": scamType,
      "country": country,
      "comment": comment
    ]
    request.httpBody = try JSONEncoder().encode(body)

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse else {
      throw ReportError.serverError
    }

    switch httpResponse.statusCode {
    case 200, 201:
      break // proceed to decoding
    default:
      throw ReportError.createFailed
    }

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(.apiFormat)
    return try decoder.decode(UrlReportDetails.self, from: data)
  }

  func addCommentToReport(
    url: String,
    comment: String
  ) async throws -> UrlReportDetails? {
    let apiUrl = baseURL.appendingPathComponent("url-reports/\(url)/comments")
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
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .formatted(.apiFormat)
      return try decoder.decode(UrlReportDetails.self, from: data)
    case 404:
      return nil
    default:
      throw ReportError.updateFailed
    }
  }

  func deleteReportBy(url: String) async throws -> Bool {
    let apiUrl = baseURL.appendingPathComponent("url-reports/\(url)")
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
