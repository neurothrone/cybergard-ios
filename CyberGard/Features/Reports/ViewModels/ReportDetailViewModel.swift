import Combine
import Foundation

@MainActor
final class ReportDetailViewModel: ObservableObject {
  @Published var isLoading = false
  @Published var shouldRefresh = false
  @Published var error: String?

  @Published var report: ReportDetails?
  @Published var comment: String = ""
  @Published var scamType: ScamType = .default

  private let reportType: ReportType
  private let identifier: String
  private let service: ReportHandling
  private let reportUpdateSubject: PassthroughSubject<ReportDetails, Never>?

  init(
    reportType: ReportType,
    identifier: String,
    service: ReportHandling,
    reportUpdateSubject: PassthroughSubject<ReportDetails, Never>? = nil
  ) {
    self.reportType = reportType
    self.identifier = identifier
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
      report = try await service.getBy(type: reportType, identifier: identifier)
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
        type: reportType,
        identifier: identifier,
        comment: scamType == .other ? comment : scamType.rawValue
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
