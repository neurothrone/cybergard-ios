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
        }
      }
      .navigationTitle("Email Reports")
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
