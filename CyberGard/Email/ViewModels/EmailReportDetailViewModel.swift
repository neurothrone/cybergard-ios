import Combine
import Foundation

@MainActor
class EmailReportDetailViewModel: ObservableObject {
  @Published var report: EmailReportDetails?
  @Published var isLoading = false
  @Published var error: String?

  private let service: EmailReportHandling
  private let email: String
  private let reportUpdateSubject: PassthroughSubject<EmailReportDetails, Never>?

  init(
    email: String,
    service: EmailReportHandling,
    reportUpdateSubject: PassthroughSubject<EmailReportDetails, Never>? = nil
  ) {
    self.email = email
    self.service = service
    self.reportUpdateSubject = reportUpdateSubject
  }

  func loadReport() async {
    isLoading = true
    error = nil
    
    do {
      report = try await service.getByEmailAsync(email: email)
    } catch {
      self.error = "Failed to load report: \(error.localizedDescription)"
    }
    
    isLoading = false
  }

  func addComment(_ comment: String) async -> Bool {
    isLoading = true
    error = nil
    
    do {
      if let updated = try await service.addCommentToEmailReportAsync(
        email: email,
        comment: comment
      ) {
        report = updated
        reportUpdateSubject?.send(updated)
        isLoading = false
        return true
      } else {
        error = "Report not found."
      }
    } catch {
      self.error = "Failed to add comment: \(error.localizedDescription)"
    }
    
    isLoading = false
    return false
  }
}
