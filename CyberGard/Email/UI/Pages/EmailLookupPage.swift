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
          List {
            ForEach(viewModel.filteredReports) { report in
              NavigationLink {
                EmailReportDetailPage(
                  viewModel: EmailReportDetailViewModel(
                    email: report.email,
                    service: service,
                    reportUpdateSubject: viewModel.reportUpdateSubject
                  )
                )
              } label: {
                EmailReportCellView(report: report)
              }
            }
          }
          .refreshable {
            await viewModel.loadReports()
          }
          .searchable(
            text: $viewModel.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search by email, scam, or country"
          )
        }
      }
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

#Preview {
  EmailLookupPage(service: EmailReportInMemoryService())
}
