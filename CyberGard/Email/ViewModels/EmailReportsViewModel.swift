import Combine
import Foundation

@MainActor
final class EmailReportsViewModel: ObservableObject {
  @Published var isLoading = false
  @Published var error: String?

  @Published var reports: [EmailReport] = []
  @Published var hasSearched: Bool = false
  @Published var searchText: String = ""

  // Pagination state
  @Published var isLoadingMore = false
  @Published var hasMorePages = true
  private(set) var currentPage = 1
  private let pageSize = 10

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
    $searchText
      .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
      .removeDuplicates()
      .sink { [weak self] text in
        guard let self = self else { return }
        self.reports = []
        self.currentPage = 1
        self.hasMorePages = true
        self.hasSearched = false
        if !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
          Task { await self.loadReports(reset: true) }
        }
      }
      .store(in: &cancellables)
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

  func loadReports(reset: Bool = false) async {
    guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

    if reset {
      currentPage = 1
      hasMorePages = true
      reports = []
    }

    isLoading = true
    error = nil

    try? await Task.sleep(for: .seconds(1))  // Simulate network delay

    do {
      let newReports = try await service.searchReportsAsync(
        page: 1,
        pageSize: pageSize,
        query: searchText
      )
      reports = newReports
      hasMorePages = newReports.count == pageSize
      currentPage = 1
      hasSearched = true
    } catch {
      self.error = "Failed to load reports: \(error.localizedDescription)"
    }

    isLoading = false
  }

  func loadNextPage() async {
    guard !isLoadingMore, hasMorePages,
      !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    else { return }
    
    isLoadingMore = true
    error = nil

    try? await Task.sleep(for: .seconds(1))  // Simulate network delay

    do {
      let nextPage = currentPage + 1
      let newReports = try await service.searchReportsAsync(
        page: nextPage,
        pageSize: pageSize,
        query: searchText
      )
      if newReports.isEmpty {
        hasMorePages = false
      } else {
        reports.append(contentsOf: newReports)
        currentPage = nextPage
        hasMorePages = newReports.count == pageSize
      }
    } catch {
      self.error = "Failed to load more reports: \(error.localizedDescription)"
    }

    isLoadingMore = false
  }

  func deleteReport(_ report: EmailReport) async {
    error = nil

    guard let index = reports.firstIndex(where: { $0.email == report.email }) else {
      error = "Report not found"
      return
    }

    isLoading = true
    defer { isLoading = false }

    do {
      let success = try await service.deleteEmailReportAsync(email: report.email)
      guard success else {
        error = "Failed to delete report"
        return
      }

      reports.remove(at: index)
    } catch {
      self.error = "Failed to delete report: \(error.localizedDescription)"
    }
  }
}
