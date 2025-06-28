import Foundation

final class ReportPreviewService: ReportHandling {
  private var reports: [ReportDetails]

  init(
    initialReports: [ReportDetails] = []
  ) {
    self.reports = initialReports
  }

  func searchReports(
    type: ReportType,
    page: Int = 1,
    pageSize: Int = 10,
    query: String? = nil
  ) async throws -> SearchReportResponse {
    var filtered = reports

    if let query = query, !query.isEmpty {
      let lower = query.lowercased()
      filtered = filtered.filter { r in
        r.reportType == type
          && r.identifier.lowercased().contains(lower)
          || r.country.lowercased().contains(lower)
          || r.scamType.rawValue.lowercased().contains(lower)
      }
    }

    let startIndex = (page - 1) * pageSize
    guard startIndex < filtered.count else {
      return SearchReportResponse(
        items: [],
        totalCount: filtered.count
      )
    }

    let endIndex = min(startIndex + pageSize, filtered.count)
    let paginatedReports = filtered[startIndex..<endIndex]

    let results = paginatedReports.map { report in
      ReportItem(
        reportType: type,
        identifier: report.identifier,
        scamType: report.scamType,
        country: report.country,
        reportedDate: report.reportedDate,
        commentsCount: report.comments.count
      )
    }
    return SearchReportResponse(
      items: results,
      totalCount: filtered.count
    )
  }

  func getBy(
    type: ReportType,
    identifier: String
  ) async throws -> ReportDetails? {
    reports.first { $0.identifier == identifier }
  }

  func createReport(
    type: ReportType,
    identifier: String,
    scamType: String,
    country: String,
    comment: String
  ) async throws -> ReportDetails {
    guard type.isValid(identifier) else {
      throw ReportError.badRequest(message: "Invalid \(type).")
    }

    if let index = reports.firstIndex(where: { $0.identifier == identifier }) {
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
      let report = ReportDetails(
        reportType: type,
        identifier: identifier,
        scamType: ScamType(rawValue: scamType) ?? .other,
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
    type: ReportType,
    identifier: String,
    comment: String
  ) async throws -> ReportDetails? {
    guard type.isValid(identifier) else {
      throw ReportError.badRequest(message: "Invalid \(type).")
    }

    guard let index = reports.firstIndex(where: { $0.identifier == identifier }) else {
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

  func deleteReportBy(
    type: ReportType,
    identifier: String
  ) async throws -> Bool {
    guard type.isValid(identifier) else {
      throw ReportError.badRequest(message: "Invalid \(type).")
    }

    if let index = reports.firstIndex(where: { $0.identifier == identifier }) {
      reports.remove(at: index)
      return true
    }
    return false
  }
}
