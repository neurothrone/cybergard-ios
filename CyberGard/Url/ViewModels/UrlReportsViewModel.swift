import Combine
import Foundation

@MainActor
final class UrlReportsViewModel: ObservableObject {
  @Published var isLoading = false
  @Published var error: String?

  @Published var reports: [UrlReport] = []
  @Published var hasSearched: Bool = false
  @Published var searchText: String = ""

  // Pagination state
  @Published var isLoadingMore = false
  @Published var hasMorePages = true
  private(set) var currentPage = 1
  private let pageSize = 10
  private(set) var totalReports = 0

  private let service: UrlReportHandling
  let reportCreateSubject = PassthroughSubject<UrlReportDetails, Never>()
  let reportUpdateSubject = PassthroughSubject<UrlReportDetails, Never>()
  private var cancellables = Set<AnyCancellable>()

  var shouldShowNoResults: Bool {
    hasSearched && !isLoading && !isLoadingMore && reports.isEmpty && !searchText.isEmpty
  }

  init(service: UrlReportHandling) {
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
        self.totalReports = 0
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

  private func addReport(_ report: UrlReportDetails) {
    reports.append(UrlReport.from(details: report))
    totalReports += 1
  }

  private func updateReport(_ updatedReport: UrlReportDetails) {
    if let index = reports.firstIndex(where: { $0.url == updatedReport.url }) {
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
      totalReports = 0
    }

    isLoading = true
    error = nil

    // TODO: Remove this delay in production code
    if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
      try? await Task.sleep(for: .seconds(1))  // Simulate network delay only in Previews
    }

    do {
      let response: UrlReportResponse = try await service.searchReports(
        page: 1,
        pageSize: pageSize,
        query: searchText
      )
      reports = response.results
      totalReports = response.total
      hasMorePages = reports.count < totalReports
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

    // TODO: Remove this delay in production code
    if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
      try? await Task.sleep(for: .seconds(1))  // Simulate network delay only in Previews
    }

    do {
      let nextPage = currentPage + 1
      let response: UrlReportResponse = try await service.searchReports(
        page: nextPage,
        pageSize: pageSize,
        query: searchText
      )
      reports.append(contentsOf: response.results)
      totalReports = response.total
      currentPage = nextPage
      hasMorePages = reports.count < totalReports
    } catch {
      self.error = "Failed to load more reports: \(error.localizedDescription)"
    }

    isLoadingMore = false
  }

  func deleteReport(_ report: UrlReport) async {
    error = nil

    guard let index = reports.firstIndex(where: { $0.url == report.url }) else {
      error = "Report not found"
      return
    }

    isLoading = true
    defer { isLoading = false }

    do {
      let success = try await service.deleteReportBy(url: report.url)
      guard success else {
        error = "Failed to delete report"
        return
      }

      reports.remove(at: index)
      totalReports = max(0, totalReports - 1)
      hasMorePages = reports.count < totalReports
    } catch {
      self.error = "Failed to delete report: \(error.localizedDescription)"
    }
  }
}
