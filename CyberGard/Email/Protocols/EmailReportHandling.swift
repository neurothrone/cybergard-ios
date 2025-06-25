protocol EmailReportHandling {
  func getAllAsync(
    page: Int,
    pageSize: Int,
    query: String?
  ) async throws -> [EmailReport]
  
  func getByEmailAsync(email: String) async throws -> EmailReportDetails?

  func createEmailReportAsync(
    email: String,
    scamType: String,
    country: String,
    comment: String
  ) async throws -> EmailReportDetails

  func addCommentToEmailReportAsync(
    email: String,
    comment: String
  ) async throws -> EmailReportDetails?

  func deleteEmailReportAsync(email: String) async throws -> Bool
}
