import Combine
import Foundation

@MainActor
final class EmailReportsViewModel: ObservableObject {
  @Published var isLoading = false
  @Published var error: String?

  @Published var searchText: String = ""
  @Published var reports: [EmailReport] = []
  @Published private(set) var filteredReports: [EmailReport] = []

  private let service: EmailReportHandling
  let reportCreateSubject = PassthroughSubject<EmailReportDetails, Never>()
  let reportUpdateSubject = PassthroughSubject<EmailReportDetails, Never>()
  private var cancellables = Set<AnyCancellable>()

  init(service: EmailReportHandling) {
    self.service = service
    setupSearchDebouncer()
    setupReportSubjects()
  }

  private func setupSearchDebouncer() {
    Publishers.CombineLatest(
      $reports,
      $searchText.debounce(for: .milliseconds(300), scheduler: RunLoop.main)
    )
    .map { reports, searchText in
      guard !searchText.isEmpty else { return reports }
      let query = searchText.lowercased()
      return reports.filter { report in
        report.email.lowercased().contains(query)
          || report.country.lowercased().contains(query)
          || report.scamType.lowercased().contains(query)
      }
    }
    .assign(to: &$filteredReports)
  }

  private func setupReportSubjects() {
    reportCreateSubject
      .sink { [weak self] newReport in
        self?.addReport(newReport)
      }
      .store(in: &cancellables)
    reportUpdateSubject
      .sink { [weak self] updatedReport in
        self?.updateReport(updatedReport)
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

  private func addReport(_ report: EmailReportDetails) {
    reports.append(EmailReport.from(details: report))
  }

  private func updateReport(_ updatedReport: EmailReportDetails) {
    if let index = reports.firstIndex(where: { $0.email == updatedReport.email }) {
      // Update the existing report with the new details
      // NOTE: If we let the user update the scam type or country, we would need to uncomment these lines:
      //reports[index].scamType = updated.scamType
      //reports[index].country = updated.country
      reports[index].commentsCount = updatedReport.comments.count
    }
  }
}
