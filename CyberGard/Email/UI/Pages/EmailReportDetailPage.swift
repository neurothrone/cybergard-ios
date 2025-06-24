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
          Section {
            LabeledContent("Email", value: report.email)
            LabeledContent("Scam", value: report.scamType)
            LabeledContent("Country", value: report.country)
            LabeledContent("Reports", value: report.commentsCount.description)
          } header: {
            Text("Details")
          }

          Section {
            ForEach(report.comments, id: \.postedDate) { comment in
              CommentCellView(comment: comment)
                .listRowBackground(Color.blue.opacity(0.1))
            }
          } header: {
            Text("Comments")
          }
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
