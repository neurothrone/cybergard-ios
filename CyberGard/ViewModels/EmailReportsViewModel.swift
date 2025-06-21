import Combine
import Foundation

@MainActor
class EmailReportsViewModel: ObservableObject {
  @Published var reports: [EmailReport] = []
  @Published var isLoading = false
  @Published var error: String?

  let reportUpdateSubject = PassthroughSubject<EmailReport, Never>()
  private var cancellables = Set<AnyCancellable>()

  private let service: EmailReportHandling

  init(service: EmailReportHandling) {
    self.service = service
    reportUpdateSubject
      .sink { [weak self] updated in
        self?.updateReport(updated)
      }
      .store(in: &cancellables)
  }

  func loadReports() async {
    isLoading = true
    error = nil

    do {
      reports = try await service.getAllAsync()
    } catch {
      self.error = "Failed to load reports: \(error.localizedDescription)"
    }

    isLoading = false
  }

  private func updateReport(_ updated: EmailReport) {
    if let index = reports.firstIndex(where: { $0.email == updated.email }) {
      reports[index] = updated
    }
  }
}
