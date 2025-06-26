import SwiftUI

struct UrlLookupPage: View {
  @StateObject private var viewModel: UrlReportsViewModel

  let service: UrlReportHandling

  init(service: UrlReportHandling) {
    self.service = service
    _viewModel = StateObject(
      wrappedValue: UrlReportsViewModel(service: service)
    )
  }

  var body: some View {
    NavigationStack {
      VStack {
        if viewModel.isLoading {
          ProgressView("Loading Reports...")
        } else if let error = viewModel.error {
          Text(error)
            .foregroundColor(.red)
            .padding()
        } else {
          if viewModel.shouldShowNoResults {
            NoSearchResultsView()
          } else if !viewModel.reports.isEmpty {
            List {
              ForEach(viewModel.reports) { report in
                UrlReportRowView(
                  viewModel: viewModel,
                  report: report,
                  service: service
                )
              }
              if viewModel.hasMorePages {
                HStack {
                  Spacer()
                  if viewModel.isLoadingMore {
                    ProgressView()
                  } else {
                    Button("Load More") {
                      Task { await viewModel.loadNextPage() }
                    }
                  }
                  Spacer()
                }
              }
              
              // Show total results only if there are any
              if viewModel.totalReports > 0 {
                HStack {
                  Spacer()
                  Text("Showing \(viewModel.reports.count) of \(viewModel.totalReports) results")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                  Spacer()
                }
              }
            }
            .refreshable {
              await viewModel.loadReports(reset: true)
            }
          } else {
            LookupPlaceholderView(
              icon: "link",
              title: "Search or report a suspicious URL",
              subtitle: "Use the search bar above or tap the flag to report a new url."
            )
          }
        }
      }
      .searchable(
        text: $viewModel.searchText,
        placement: .navigationBarDrawer(displayMode: .always),
        prompt: "Search by url, scam, or country"
      )
      .navigationTitle("Url Lookup")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          NavigationLink(
            destination: NewUrlReportPage(
              viewModel: NewUrlReportViewModel(
                service: service,
                reportCreateSubject: viewModel.reportCreateSubject
              )
            )
          ) {
            Image(systemName: "flag")
              .foregroundStyle(.red)
          }
        }
      }
      .task {
        if viewModel.reports.isEmpty {
          await viewModel.loadReports()
        }
      }
    }
  }
}

// Helper row view to reduce type-checking complexity
private struct UrlReportRowView: View {
  @ObservedObject var viewModel: UrlReportsViewModel

  let report: UrlReport
  let service: UrlReportHandling

  var body: some View {
    NavigationLink(
      destination: UrlReportDetailPage(
        viewModel: UrlReportDetailViewModel(
          url: report.url,
          service: service,
          reportUpdateSubject: viewModel.reportUpdateSubject
        )
      )
    ) {
      UrlReportCellView(report: report)
    }
  }
}

#Preview {
  UrlLookupPage(
    service: UrlReportInMemoryService()
  )
}
