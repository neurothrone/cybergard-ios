import SwiftUI

struct PhoneReportDetailPage: View {
  @StateObject private var viewModel: PhoneReportDetailViewModel
  @State private var isReporting = false

  init(viewModel: PhoneReportDetailViewModel) {
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
          PhoneReportDetailsSectionView(report: report)
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
        ReportPhoneSheet(viewModel: viewModel)
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
  let phoneReport = PhoneReportDetails.sample
  let viewModel = PhoneReportDetailViewModel(
    phoneNumber: phoneReport.phoneNumber,
    service: PhoneReportInMemoryService()
  )
  viewModel.report = phoneReport

  return NavigationStack {
    PhoneReportDetailPage(
      viewModel: viewModel
    )
  }
}
