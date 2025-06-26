import Foundation

final class PhoneReportInMemoryService: PhoneReportHandling {
  private var reports: [PhoneReportDetails] = PhoneReportDetails.samples

  func searchReports(
    page: Int = 1,
    pageSize: Int = 10,
    query: String? = nil
  ) async throws -> PhoneReportResponse {
    var filtered = reports

    if let query = query, !query.isEmpty {
      let lower = query.lowercased()
      filtered = filtered.filter { r in
        r.phoneNumber.lowercased().contains(lower)
          || r.country.lowercased().contains(lower)
          || r.scamType.lowercased().contains(lower)
      }
    }

    let startIndex = (page - 1) * pageSize
    guard startIndex < filtered.count else {
      return PhoneReportResponse(
        results: [],
        total: filtered.count
      )
    }

    let endIndex = min(startIndex + pageSize, filtered.count)
    let paginatedReports = filtered[startIndex..<endIndex]

    let results = paginatedReports.map { report in
      PhoneReport(
        phoneNumber: report.phoneNumber,
        scamType: report.scamType,
        country: report.country,
        reportedDate: report.reportedDate,
        commentsCount: report.comments.count
      )
    }

    return PhoneReportResponse(
      results: results,
      total: filtered.count
    )
  }

  func getBy(phoneNumber: String) async throws -> PhoneReportDetails? {
    reports.first { $0.phoneNumber == phoneNumber }
  }

  func createReport(
    phoneNumber: String,
    scamType: String,
    country: String,
    comment: String
  ) async throws -> PhoneReportDetails {
    guard PhoneValidator.isValidPhoneNumber(phoneNumber) else {
      throw ReportError.badRequest(message: "Invalid phone number.")
    }

    if let index = reports.firstIndex(where: { $0.phoneNumber == phoneNumber }) {
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
      let report = PhoneReportDetails(
        phoneNumber: phoneNumber,
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
    phoneNumber: String,
    comment: String
  ) async throws -> PhoneReportDetails? {
    guard PhoneValidator.isValidPhoneNumber(phoneNumber) else {
      throw ReportError.badRequest(message: "Invalid phone number.")
    }

    guard let index = reports.firstIndex(where: { $0.phoneNumber == phoneNumber }) else {
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

  func deleteReportBy(phoneNumber: String) async throws -> Bool {
    guard PhoneValidator.isValidPhoneNumber(phoneNumber) else {
      throw ReportError.badRequest(message: "Invalid phone number.")
    }

    if let index = reports.firstIndex(where: { $0.phoneNumber == phoneNumber }) {
      reports.remove(at: index)
      return true
    }
    return false
  }
}
