import Combine
import Foundation

@MainActor
final class UrlReportDetailViewModel: ObservableObject {
  @Published var isLoading = false
  @Published var shouldRefresh = false
  @Published var error: String?

  @Published var report: UrlReportDetails?
  @Published var comment: String = ""
  @Published var scamType: ScamType = .default

  private let url: String
  private let service: UrlReportHandling
  private let reportUpdateSubject: PassthroughSubject<UrlReportDetails, Never>?

  init(
    url: String,
    service: UrlReportHandling,
    reportUpdateSubject: PassthroughSubject<UrlReportDetails, Never>? = nil
  ) {
    self.url = url
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
      report = try await service.getBy(url: url)
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
        url: url,
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
