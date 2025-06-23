import SwiftUI

struct EmailLookupScreen: View {
  @Environment(\.emailReportService) private var emailReportService
  @StateObject private var viewModel: EmailReportsViewModel

  init(service: EmailReportHandling) {
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
          List(viewModel.reports, id: \.email) { report in
            NavigationLink(
              destination:
                EmailReportDetailScreen(
                  viewModel: EmailReportDetailViewModel(
                    email: report.email,
                    service: emailReportService,
                    reportUpdateSubject: viewModel.reportUpdateSubject
                  )
                )
            ) {
              EmailReportCellView(report: report)
            }
          }
          .refreshable {
            await viewModel.loadReports()
          }
          .searchable(
            text: .constant(""),
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
                service: emailReportService,
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
  EmailLookupScreen(service: EmailReportInMemoryService())
}
