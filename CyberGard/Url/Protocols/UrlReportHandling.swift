protocol UrlReportHandling {
  func searchReports(
    page: Int,
    pageSize: Int,
    query: String?
  ) async throws -> UrlReportResponse

  func getBy(url: String) async throws -> UrlReportDetails?

  func createReport(
    url: String,
    scamType: String,
    country: String,
    comment: String
  ) async throws -> UrlReportDetails

  func addCommentToReport(
    url: String,
    comment: String
  ) async throws -> UrlReportDetails?

  func deleteReportBy(url: String) async throws -> Bool
}
