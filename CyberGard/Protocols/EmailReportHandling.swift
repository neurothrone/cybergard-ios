protocol EmailReportHandling {
  func getAllAsync() async throws -> [EmailReport]
  func getByEmailAsync(email: String) async throws -> EmailReport?

  func createEmailReportAsync(
    email: String,
    scamType: String,
    country: String,
    comment: String
  ) async throws -> EmailReport

  func addCommentToEmailReportAsync(
    email: String,
    comment: String
  ) async throws -> EmailReport?

  func deleteEmailReportAsync(email: String) async throws -> Bool
}
