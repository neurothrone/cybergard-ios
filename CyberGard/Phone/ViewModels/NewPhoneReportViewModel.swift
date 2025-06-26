import Combine
import Foundation

@MainActor
final class NewPhoneReportViewModel: ObservableObject {
  @Published var isLoading = false
  @Published var error: String?

  @Published var phoneNumber: String = ""
  @Published var country: String = ""
  @Published var comment: String = ""
  @Published var scamType: ScamType = .spamOrTelemarketing

  private let service: PhoneReportHandling
  private let reportCreateSubject: PassthroughSubject<PhoneReportDetails, Never>?

  init(
    service: PhoneReportHandling,
    reportCreateSubject: PassthroughSubject<PhoneReportDetails, Never>? = nil
  ) {
    self.service = service
    self.reportCreateSubject = reportCreateSubject
  }

  var isValid: Bool {
    guard PhoneValidator.isValidPhoneNumber(phoneNumber) else {
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
        phoneNumber: phoneNumber,
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
