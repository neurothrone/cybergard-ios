import Foundation

final class PhoneReportApiService: PhoneReportHandling {
  private let baseURL: URL

  init(baseURL: URL = URL(string: "http://localhost:5001/api")!) {
    self.baseURL = baseURL
  }

  func searchReports(
    page: Int = 1,
    pageSize: Int = 10,
    query: String? = nil
  ) async throws -> PhoneReportResponse {
    var queryItems: [URLQueryItem] = [
        URLQueryItem(name: "page", value: "\(page)"),
        URLQueryItem(name: "pageSize", value: "\(pageSize)")
    ]
    if let query = query, !query.isEmpty {
        queryItems.append(URLQueryItem(name: "query", value: query))
    }
    let url = baseURL
        .appendingPathComponent("phone-reports")
        .appending(queryItems: queryItems)
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse,
          200..<300 ~= httpResponse.statusCode else {
      throw ReportError.serverError
    }

    do {
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .formatted(.apiFormat)
      return try decoder.decode(PhoneReportResponse.self, from: data)
    } catch {
      throw ReportError.decodingFailed
    }
  }
  
  func getBy(phoneNumber: String) async throws -> PhoneReportDetails? {
    let url = baseURL.appendingPathComponent("phone-reports/\(phoneNumber)")
    let (data, response) = try await URLSession.shared.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse else {
      throw ReportError.serverError
    }

    switch httpResponse.statusCode {
    case 200:
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .formatted(.apiFormat)
      return try decoder.decode(PhoneReportDetails.self, from: data)
    case 404:
      return nil
    default:
      throw ReportError.serverError
    }
  }

  func createReport(
    phoneNumber: String,
    scamType: String,
    country: String,
    comment: String
  ) async throws -> PhoneReportDetails {
    let url = baseURL.appendingPathComponent("phone-reports")
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let body: [String: String] = [
      "phone-number": phoneNumber,
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
    return try decoder.decode(PhoneReportDetails.self, from: data)
  }

  func addCommentToReport(
    phoneNumber: String,
    comment: String
  ) async throws -> PhoneReportDetails? {
    let url = baseURL.appendingPathComponent("phone-reports/\(phoneNumber)/comments")
    var request = URLRequest(url: url)
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
      return try decoder.decode(PhoneReportDetails.self, from: data)
    case 404:
      return nil
    default:
      throw ReportError.updateFailed
    }
  }

  func deleteReport(phoneNumber: String) async throws -> Bool {
    let url = baseURL.appendingPathComponent("phone-reports/\(phoneNumber)")
    var request = URLRequest(url: url)
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
