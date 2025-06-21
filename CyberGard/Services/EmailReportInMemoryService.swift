import Foundation

enum ReportError: Error {
  case badRequest(message: String)
  case notFound
  case serverError
  case createFailed
  case updateFailed
  case deleteFailed
  case decodingFailed
  case invalidURL
}

class EmailReportInMemoryService: EmailReportHandling {
  private var reports: [EmailReport] = EmailReport.samples

  func getAllAsync() async throws -> [EmailReport] {
    reports
  }

  func getByEmailAsync(email: String) async throws -> EmailReport? {
    reports.first { $0.email == email }
  }
  
  func createEmailReportAsync(
    email: String,
    scamType: String,
    country: String,
    comment: String
  ) async throws -> EmailReport {
    guard ReportValidator.isValidEmail(email) else {
      throw ReportError.badRequest(message: "Invalid email address.")
    }
    
    if let index = reports.firstIndex(where: { $0.email == email }) {
      var existingReport = reports[index]
      existingReport.reports.append(
        ReportItem(
          comment: comment,
          date: .now
        )
      )
      reports[index] = existingReport
      return existingReport
    } else {
      let timeOfReport: Date = .now
      let report = EmailReport(
        email: email,
        scamType: scamType,
        country: country,
        reportedDate: timeOfReport,
        reports: [
          ReportItem(
            comment: comment,
            date: timeOfReport
          )
        ]
      )
      reports.append(report)
      return report
    }
  }

  func addCommentToEmailReportAsync(
    email: String,
    comment: String
  ) async throws -> EmailReport? {
    guard ReportValidator.isValidEmail(email) else {
      throw ReportError.badRequest(message: "Invalid email address.")
    }
    
    guard let index = reports.firstIndex(where: { $0.email == email }) else {
      return nil
    }
    
    var updatedReport = reports[index]
    updatedReport.reports.append(
      ReportItem(
        comment: comment,
        date: .now
      )
    )
    reports[index] = updatedReport
    
    return updatedReport
  }

  func deleteEmailReportAsync(email: String) async throws -> Bool {
    guard ReportValidator.isValidEmail(email) else {
      throw ReportError.badRequest(message: "Invalid email address.")
    }
    
    if let index = reports.firstIndex(where: { $0.email == email }) {
      reports.remove(at: index)
      return true
    }
    return false
  }
}
