protocol PhoneReportHandling {
  func searchReports(
    page: Int,
    pageSize: Int,
    query: String?
  ) async throws -> PhoneReportResponse

  func getBy(phoneNumber: String) async throws -> PhoneReportDetails?

  func createReport(
    phoneNumber: String,
    scamType: String,
    country: String,
    comment: String
  ) async throws -> PhoneReportDetails

  func addCommentToReport(
    phoneNumber: String,
    comment: String
  ) async throws -> PhoneReportDetails?

  func deleteReportBy(phoneNumber: String) async throws -> Bool
}
