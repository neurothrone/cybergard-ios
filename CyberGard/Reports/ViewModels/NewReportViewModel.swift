import Combine
import Foundation

@MainActor
final class NewReportViewModel: ObservableObject {
  @Published var isLoading = false
  @Published var error: String?

  @Published var identifier: String = ""
  @Published var country: String = ""
  @Published var comment: String = ""
  @Published var scamType: ScamType = .default

  private let reportType: ReportType
  private let service: ReportHandling
  private let reportCreateSubject: PassthroughSubject<ReportDetails, Never>?

  init(
    reportType: ReportType,
    service: ReportHandling,
    reportCreateSubject: PassthroughSubject<ReportDetails, Never>? = nil
  ) {
    self.reportType = reportType
    self.service = service
    self.reportCreateSubject = reportCreateSubject
  }

  var isValid: Bool {
    guard reportType.isValid(identifier) else {
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
        type: reportType,
        identifier: identifier,
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
