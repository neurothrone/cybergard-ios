import Foundation

final class UrlReportInMemoryService: UrlReportHandling {
  private var reports: [UrlReportDetails] = UrlReportDetails.samples

  func searchReports(
    page: Int = 1,
    pageSize: Int = 10,
    query: String? = nil
  ) async throws -> UrlReportResponse {
    var filtered = reports

    if let query = query, !query.isEmpty {
      let lower = query.lowercased()
      filtered = filtered.filter { r in
        r.url.lowercased().contains(lower)
          || r.country.lowercased().contains(lower)
          || r.scamType.lowercased().contains(lower)
      }
    }

    let startIndex = (page - 1) * pageSize
    guard startIndex < filtered.count else {
      return UrlReportResponse(
        results: [],
        total: filtered.count
      )
    }

    let endIndex = min(startIndex + pageSize, filtered.count)
    let paginatedReports = filtered[startIndex..<endIndex]

    let results = paginatedReports.map { report in
      UrlReport(
        url: report.url,
        scamType: report.scamType,
        country: report.country,
        reportedDate: report.reportedDate,
        commentsCount: report.comments.count
      )
    }

    return UrlReportResponse(
      results: results,
      total: filtered.count
    )
  }

  func getBy(url: String) async throws -> UrlReportDetails? {
    reports.first { $0.url == url }
  }

  func createReport(
    url: String,
    scamType: String,
    country: String,
    comment: String
  ) async throws -> UrlReportDetails {
    guard UrlValidator.isValidUrl(url) else {
      throw ReportError.badRequest(message: "Invalid url.")
    }

    if let index = reports.firstIndex(where: { $0.url == url }) {
      var existingReport = reports[index]
      existingReport.comments.append(
        Comment(
          text: comment,
          postedDate: .now
        )
      )
      reports[index] = existingReport
      return existingReport
    } else {
      let timeOfReport: Date = .now
      let report = UrlReportDetails(
        url: url,
        scamType: scamType,
        country: country,
        reportedDate: timeOfReport,
        comments: [
          Comment(
            text: comment,
            postedDate: timeOfReport
          )
        ]
      )
      reports.append(report)
      return report
    }
  }

  func addCommentToReport(
    url: String,
    comment: String
  ) async throws -> UrlReportDetails? {
    guard UrlValidator.isValidUrl(url) else {
      throw ReportError.badRequest(message: "Invalid url.")
    }

    guard let index = reports.firstIndex(where: { $0.url == url }) else {
      return nil
    }

    var updatedReport = reports[index]
    updatedReport.comments.append(
      Comment(
        text: comment,
        postedDate: .now
      )
    )
    reports[index] = updatedReport

    return updatedReport
  }

  func deleteReportBy(url: String) async throws -> Bool {
    guard UrlValidator.isValidUrl(url) else {
      throw ReportError.badRequest(message: "Invalid url.")
    }

    if let index = reports.firstIndex(where: { $0.url == url }) {
      reports.remove(at: index)
      return true
    }
    return false
  }
}
