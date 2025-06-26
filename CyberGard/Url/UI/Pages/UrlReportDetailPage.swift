import SwiftUI

struct UrlReportDetailPage: View {
  @StateObject private var viewModel: UrlReportDetailViewModel
  @State private var isReporting = false

  init(viewModel: UrlReportDetailViewModel) {
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
          UrlReportDetailsSectionView(report: report)
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
        ReportUrlSheet(viewModel: viewModel)
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
  let urlReport = UrlReportDetails.sample
  let viewModel = UrlReportDetailViewModel(
    url: urlReport.url,
    service: UrlReportInMemoryService()
  )
  viewModel.report = urlReport

  return NavigationStack {
    UrlReportDetailPage(
      viewModel: viewModel
    )
  }
}
