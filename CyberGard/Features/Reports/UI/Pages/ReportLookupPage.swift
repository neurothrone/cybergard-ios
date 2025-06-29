import SwiftUI

struct ReportLookupPage: View {
  @StateObject private var viewModel: ReportsViewModel

  let service: ReportHandling

  init(service: ReportHandling) {
    self.service = service
    _viewModel = StateObject(
      wrappedValue: ReportsViewModel(service: service)
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
                ReportRowView(
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
              icon: "magnifyingglass",
              title: "Search for reports",
              subtitle: "Use the search bar above or tap the flag to report something suspicious"
            )
          }
        }
      }
      .searchable(
        text: $viewModel.searchText,
        placement: .navigationBarDrawer(displayMode: .always),
        prompt: "Search for emails, phones, urls"
      )
      .navigationTitle("Reports")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          NavigationLink(
            destination: NewReportPage(
              viewModel: NewReportViewModel(
                service: service,
                reportCreateSubject: viewModel.reportCreateSubject
              )
            )
          ) {
            Label("New Report", systemImage: "plus.circle")
              .labelStyle(.titleAndIcon)
              .foregroundColor(.blue)
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
private struct ReportRowView: View {
  @ObservedObject var viewModel: ReportsViewModel

  let report: ReportItem
  let service: ReportHandling

  var body: some View {
    NavigationLink(
      destination: ReportDetailPage(
        viewModel: ReportDetailViewModel(
          reportType: report.reportType,
          identifier: report.identifier,
          service: service,
          reportUpdateSubject: viewModel.reportUpdateSubject
        )
      )
    ) {
      ReportCellView(report: report)
    }
  }
}

#Preview {
  ReportLookupPage(
    service: ReportPreviewService(
      initialReports: ReportDetails.loadSampleReports()
    )
  )
}
