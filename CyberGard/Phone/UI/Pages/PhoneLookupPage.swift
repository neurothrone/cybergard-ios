import SwiftUI

struct PhoneLookupPage: View {
  @StateObject private var viewModel: PhoneReportsViewModel

  let service: PhoneReportHandling

  init(service: PhoneReportHandling) {
    self.service = service
    _viewModel = StateObject(
      wrappedValue: PhoneReportsViewModel(service: service)
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
                PhoneReportRowView(
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
              icon: "phone.fill",
              title: "Search or report a suspicious phone number",
              subtitle: "Use the search bar above or tap the flag to report a new phone number."
            )
          }
        }
      }
      .searchable(
        text: $viewModel.searchText,
        placement: .navigationBarDrawer(displayMode: .always),
        prompt: "Search by phone number, scam, or country"
      )
      .navigationTitle("Phone Lookup")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          NavigationLink(
            destination: NewPhoneReportPage(
              viewModel: NewPhoneReportViewModel(
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
private struct PhoneReportRowView: View {
  @ObservedObject var viewModel: PhoneReportsViewModel

  let report: PhoneReport
  let service: PhoneReportHandling

  var body: some View {
    NavigationLink(
      destination: PhoneReportDetailPage(
        viewModel: PhoneReportDetailViewModel(
          phoneNumber: report.phoneNumber,
          service: service,
          reportUpdateSubject: viewModel.reportUpdateSubject
        )
      )
    ) {
      PhoneReportCellView(report: report)
    }
  }
}

#Preview {
  PhoneLookupPage(
    service: PhoneReportInMemoryService()
  )
}
