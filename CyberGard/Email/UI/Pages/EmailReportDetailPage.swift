import SwiftUI

struct EmailReportDetailPage: View {
  @StateObject private var viewModel: EmailReportDetailViewModel
  @State private var isReporting = false

  init(viewModel: EmailReportDetailViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    VStack(alignment: .leading) {
      if viewModel.isLoading {
        ProgressView("Loading...")
          .padding()
      } else if let error = viewModel.error {
        Text(error)
          .foregroundColor(.red)
          .padding()
      } else if let report = viewModel.report {
        List {
          ReportDetailsSectionView(report: report)
          CommentsSectionView(comments: report.comments)
        }
        .refreshable {
          viewModel.shouldRefresh = true
        }
      }
    }
    .navigationTitle("Report Details")
    .navigationBarTitleDisplayMode(.inline)
    .sheet(isPresented: $isReporting) {
      if viewModel.report != nil {
        ReportEmailSheet(viewModel: viewModel)
      }
    }
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button {
          isReporting = true
        } label: {
          Text("Report")
            .foregroundColor(.red)
        }
      }
    }
    .task {
      await viewModel.loadReport()
    }
    .onChange(of: viewModel.shouldRefresh) {
      guard viewModel.shouldRefresh else { return }
      Task { await viewModel.refreshReport() }
    }
  }
}

#Preview {
  let emailReport = EmailReportDetails.sample
  let viewModel = EmailReportDetailViewModel(
    email: emailReport.email,
    service: EmailReportInMemoryService()
  )
  viewModel.report = emailReport

  return NavigationStack {
    EmailReportDetailPage(viewModel: viewModel)
  }
}
