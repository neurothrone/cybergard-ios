protocol PhoneReportHandling {
  func searchReportsAsync(
    page: Int,
    pageSize: Int,
    query: String?
  ) async throws -> [PhoneReport]

  func getByPhoneNumberAsync(phoneNumber: String) async throws -> PhoneReportDetails?

  func createReportAsync(
    phoneNumber: String,
    scamType: String,
    country: String,
    comment: String
  ) async throws -> PhoneReportDetails

  func addCommentToReportAsync(
    phoneNumber: String,
    comment: String
  ) async throws -> PhoneReportDetails?

  func deleteReportAsync(phoneNumber: String) async throws -> Bool
}
