import Combine
import Foundation

@MainActor
final class PhoneReportDetailViewModel: ObservableObject {
  @Published var isLoading = false
  @Published var shouldRefresh = false
  @Published var error: String?

  @Published var report: PhoneReportDetails?
  @Published var comment: String = ""
  @Published var scamType: ScamType = .default

  private let phoneNumber: String
  private let service: PhoneReportHandling
  private let reportUpdateSubject: PassthroughSubject<PhoneReportDetails, Never>?

  init(
    phoneNumber: String,
    service: PhoneReportHandling,
    reportUpdateSubject: PassthroughSubject<PhoneReportDetails, Never>? = nil
  ) {
    self.phoneNumber = phoneNumber
    self.service = service
    self.reportUpdateSubject = reportUpdateSubject
  }

  var isValid: Bool {
    if scamType == .other {
      return !comment.isEmpty
    }

    return true
  }

  func loadReport() async {
    isLoading = true
    error = nil

    do {
      report = try await service.getBy(phoneNumber: phoneNumber)
    } catch {
      self.error = "Failed to load report: \(error.localizedDescription)"
    }

    isLoading = false
  }

  func addComment() async -> Bool {
    isLoading = true
    error = nil

    defer {
      isLoading = false
    }

    do {
      if let updated = try await service.addCommentToReport(
        phoneNumber: phoneNumber,
        comment: scamType == .other ? comment : scamType.title
      ) {
        report = updated
        reportUpdateSubject?.send(updated)
        return true
      } else {
        error = "Report not found."
      }
    } catch {
      self.error = "Failed to add comment: \(error.localizedDescription)"
    }

    return false
  }

  func refreshReport() async {
    await loadReport()

    if shouldRefresh && report != nil {
      reportUpdateSubject?.send(report!)
    }
    
    shouldRefresh = false
  }
}
