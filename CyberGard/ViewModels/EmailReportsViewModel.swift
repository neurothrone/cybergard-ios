import Combine
import Foundation

@MainActor
class EmailReportsViewModel: ObservableObject {
  @Published var reports: [EmailReport] = []
  @Published var isLoading = false
  @Published var error: String?

  let reportUpdateSubject = PassthroughSubject<EmailReportDetails, Never>()
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

  func loadReports(page: Int = 1, pageSize: Int = 10) async {
    isLoading = true
    error = nil

    do {
      reports = try await service.getAllAsync(page: page, pageSize: pageSize)
    } catch {
      self.error = "Failed to load reports: \(error.localizedDescription)"
    }

    isLoading = false
  }

  private func updateReport(_ updated: EmailReportDetails) {
    if let index = reports.firstIndex(where: { $0.email == updated.email }) {
      // Update the existing report with the new details
      //reports[index].scamType = updated.scamType
      //reports[index].country = updated.country
      //reports[index].reportedDate = updated.reportedDate
      reports[index].commentsCount = updated.comments.count
    }
  }
}
