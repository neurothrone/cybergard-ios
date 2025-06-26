protocol EmailReportHandling {
  func searchReports(
    page: Int,
    pageSize: Int,
    query: String?
  ) async throws -> EmailReportResponse

  func getBy(email: String) async throws -> EmailReportDetails?

  func createReport(
    email: String,
    scamType: String,
    country: String,
    comment: String
  ) async throws -> EmailReportDetails

  func addCommentToReport(
    email: String,
    comment: String
  ) async throws -> EmailReportDetails?

  func deleteReportBy(email: String) async throws -> Bool
}
