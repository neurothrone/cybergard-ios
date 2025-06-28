import Combine
import Foundation

@MainActor
final class ReportsViewModel: ObservableObject {
  @Published var isLoading = false
  @Published var error: String?

  @Published var reports: [ReportItem] = []
  @Published var hasSearched: Bool = false
  @Published var searchText: String = ""
  
  private var reportType: ReportType = .email

  // Pagination state
  @Published var isLoadingMore = false
  @Published var hasMorePages = true
  private(set) var currentPage = 1
  private let pageSize = 10
  private(set) var totalReports = 0

  private let service: ReportHandling
  let reportCreateSubject = PassthroughSubject<ReportDetails, Never>()
  let reportUpdateSubject = PassthroughSubject<ReportDetails, Never>()
  private var cancellables = Set<AnyCancellable>()
  
  var shouldShowNoResults: Bool {
    hasSearched && !isLoading && !isLoadingMore && reports.isEmpty && !searchText.isEmpty
  }

  init(service: ReportHandling) {
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

  private func addReport(_ report: ReportDetails) {
    reports.append(ReportItem.from(details: report))
    totalReports += 1
  }

  private func updateReport(_ updatedReport: ReportDetails) {
    if let index = reports.firstIndex(where: { $0.identifier == updatedReport.identifier }) {
      // Update the existing report with the new details
      // NOTE: If we let the user update the scam type or country, we would need to uncomment these lines:
      //reports[index].scamType = updated.scamType
      //reports[index].country = updated.country
      reports[index].commentsCount = updatedReport.comments.count
    }
  }

  func loadReports(reset: Bool = false) async {
    guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
    
    // TODO: Report Type
    reportType = .email

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
      let response: SearchReportResponse = try await service.searchReports(
        type: reportType,
        page: 1,
        pageSize: pageSize,
        query: searchText
      )
      reports = response.items
      totalReports = response.totalCount
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
      let response: SearchReportResponse = try await service.searchReports(
        type: reportType,
        page: nextPage,
        pageSize: pageSize,
        query: searchText
      )
      reports.append(contentsOf: response.items)
      totalReports = response.totalCount
      currentPage = nextPage
      hasMorePages = reports.count < totalReports
    } catch {
      self.error = "Failed to load more reports: \(error.localizedDescription)"
    }

    isLoadingMore = false
  }

  func deleteReport(_ report: ReportItem) async {
    error = nil

    guard let index = reports.firstIndex(where: { $0.identifier == report.identifier }) else {
      error = "Report not found"
      return
    }

    isLoading = true
    defer { isLoading = false }

    do {
      let success = try await service.deleteReportBy(
        type: report.reportType,
        identifier: report.identifier
      )
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
