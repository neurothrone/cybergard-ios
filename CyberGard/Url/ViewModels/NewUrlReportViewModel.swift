import Combine
import Foundation

@MainActor
final class NewUrlReportViewModel: ObservableObject {
  @Published var isLoading = false
  @Published var error: String?

  @Published var url: String = ""
  @Published var country: String = ""
  @Published var comment: String = ""
  @Published var scamType: ScamType = .spamOrTelemarketing

  private let service: UrlReportHandling
  private let reportCreateSubject: PassthroughSubject<UrlReportDetails, Never>?

  init(
    service: UrlReportHandling,
    reportCreateSubject: PassthroughSubject<UrlReportDetails, Never>? = nil
  ) {
    self.service = service
    self.reportCreateSubject = reportCreateSubject
  }

  var isValid: Bool {
    guard UrlValidator.isValidUrl(url) else {
      return false
    }

    guard !country.isEmpty else {
      return false
    }

    if scamType == .other {
      return !comment.isEmpty
    }

    return true
  }

  func addNewReport() async -> Bool {
    isLoading = true
    error = nil

    defer {
      isLoading = false
    }

    do {
      let created = try await service.createReport(
        url: url,
        scamType: scamType == .other ? "Other" : scamType.title,
        country: country,
        comment: comment
      )
      reportCreateSubject?.send(created)
      return true
    } catch {
      self.error = "Failed to add new report: \(error.localizedDescription)"
      return false
    }
  }
}
