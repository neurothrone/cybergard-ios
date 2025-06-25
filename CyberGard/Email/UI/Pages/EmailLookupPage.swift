import SwiftUI

struct EmailLookupPage: View {
  @StateObject private var viewModel: EmailReportsViewModel

  let service: EmailReportHandling

  init(service: EmailReportHandling) {
    self.service = service
    _viewModel = StateObject(
      wrappedValue: EmailReportsViewModel(service: service)
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
          if viewModel.hasSearched && !viewModel.isLoading && !viewModel.isLoadingMore && !viewModel.reports.isEmpty == false && !viewModel.searchText.isEmpty {
            Spacer()
            VStack(spacing: 16) {
              Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
              Text("No results found")
                .foregroundColor(.secondary)
                .font(.title3)
            }
            Spacer()
          } else if !viewModel.reports.isEmpty {
            List {
              ForEach(Array(viewModel.reports.enumerated()), id: \.element.id) {
                index,
                report in
                EmailReportRowView(
                  viewModel: viewModel,
                  report: report,
                  service: service,
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
            }
            .refreshable {
              await viewModel.loadReports(reset: true)
            }
          }
        }
      }
      .searchable(
        text: $viewModel.searchText,
        placement: .navigationBarDrawer(displayMode: .always),
        prompt: "Search by email, scam, or country"
      )
      .navigationTitle("Email Lookup")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          NavigationLink(
            destination: NewEmailReportPage(
              viewModel: NewEmailReportViewModel(
                service: service,
                reportCreateSubject: viewModel.reportCreateSubject
              )
            )
          ) {
            Label("Report Email", systemImage: "flag")
              .foregroundColor(.red)
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
private struct EmailReportRowView: View {
  @ObservedObject var viewModel: EmailReportsViewModel

  let report: EmailReport
  let service: EmailReportHandling

  var body: some View {
    NavigationLink(
      destination: EmailReportDetailPage(
        viewModel: EmailReportDetailViewModel(
          email: report.email,
          service: service,
          reportUpdateSubject: viewModel.reportUpdateSubject
        )
      )
    ) {
      EmailReportCellView(report: report)
    }
  }
}

#Preview {
  EmailLookupPage(service: EmailReportInMemoryService())
}
