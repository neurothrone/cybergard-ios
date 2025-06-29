import SwiftUI

struct ReportDetailPage: View {
  @StateObject private var viewModel: ReportDetailViewModel
  @State private var isReporting = false

  init(viewModel: ReportDetailViewModel) {
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
        AddCommentSheet(viewModel: viewModel)
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
  let report = ReportDetails.sample
  let viewModel = ReportDetailViewModel(
    reportType: .email,
    identifier: report.identifier,
    service: ReportPreviewService()
  )
  viewModel.report = report

  return NavigationStack {
    ReportDetailPage(
      viewModel: viewModel
    )
  }
}
