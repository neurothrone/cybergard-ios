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
  private var reports: [EmailReportDetails] = EmailReportDetails.samples

  func getAllAsync(
    page: Int = 1,
    pageSize: Int = 10
  ) async throws -> [EmailReport] {
    let startIndex = (page - 1) * pageSize
    let endIndex = startIndex + pageSize
    let paginatedReports = reports[startIndex..<min(endIndex, reports.count)]
    
    return paginatedReports.map { report in
      EmailReport(
        email: report.email,
        scamType: report.scamType,
        country: report.country,
        reportedDate: report.reportedDate,
        commentsCount: report.comments.count
      )
    }
  }

  func getByEmailAsync(email: String) async throws -> EmailReportDetails? {
    reports.first { $0.email == email }
  }
  
  func createEmailReportAsync(
    email: String,
    scamType: String,
    country: String,
    comment: String
  ) async throws -> EmailReportDetails {
    guard ReportValidator.isValidEmail(email) else {
      throw ReportError.badRequest(message: "Invalid email address.")
    }
    
    if let index = reports.firstIndex(where: { $0.email == email }) {
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
      let report = EmailReportDetails(
        email: email,
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

  func addCommentToEmailReportAsync(
    email: String,
    comment: String
  ) async throws -> EmailReportDetails? {
    guard ReportValidator.isValidEmail(email) else {
      throw ReportError.badRequest(message: "Invalid email address.")
    }
    
    guard let index = reports.firstIndex(where: { $0.email == email }) else {
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
