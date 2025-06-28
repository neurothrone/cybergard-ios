protocol ReportHandling {
  func searchReports(
    type: ReportType,
    page: Int,
    pageSize: Int,
    query: String?
  ) async throws -> SearchReportResponse

  func getBy(
    type: ReportType,
    identifier: String
  ) async throws -> ReportDetails?

  func createReport(
    type: ReportType,
    identifier: String,
    scamType: String,
    country: String,
    comment: String
  ) async throws -> ReportDetails

  func addCommentToReport(
    type: ReportType,
    identifier: String,
    comment: String
  ) async throws -> ReportDetails?

  func deleteReportBy(
    type: ReportType,
    identifier: String
  ) async throws -> Bool
}
