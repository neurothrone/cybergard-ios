import SwiftUI

struct EmailReportDetailScreen: View {
  @StateObject private var viewModel: EmailReportDetailViewModel
  @State private var isReporting = false

  init(viewModel: EmailReportDetailViewModel) {
    self._viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Image(systemName: "envelope")
          .foregroundColor(.blue)
        Spacer()
        Button {
          isReporting = true
        } label: {
          Label("Report Email", systemImage: "flag")
        }
        .tint(.red)
      }
      .padding(.horizontal, 20)

      if viewModel.isLoading {
        ProgressView("Loading...")
          .padding()
      } else if let error = viewModel.error {
        Text(error)
          .foregroundColor(.red)
          .padding()
      } else if let report = viewModel.report {
        VStack(alignment: .leading, spacing: 4) {
          Text(report.email)
            .bold()
          Text("Scam Type: \(report.scamType)")
          Text("Country: \(report.country)")
          Text("Reported: \(report.reportedDate.formattedDateTime24h)")
          Text("Reports: \(report.comments.count)")
        }
        .padding(20)

        List {
          Section(header: Text("Comments")) {
            ForEach(report.comments, id: \.postedDate) { comment in
              CommentCellView(comment: comment)
                .listRowBackground(Color.blue.opacity(0.1))
            }
          }
        }
      }
    }
    .navigationTitle("Email Report")
    .navigationBarTitleDisplayMode(.inline)
    .sheet(isPresented: $isReporting) {
      if viewModel.report != nil {
        ReportEmailSheet(viewModel: viewModel)
      }
    }
    .task {
      await viewModel.loadReport()
    }
  }
}

#Preview {
  let emailReport = EmailReportDetails.samples.first ?? EmailReportDetails.sample
  let viewModel = EmailReportDetailViewModel(
    email: emailReport.email,
    service: EmailReportInMemoryService()
  )
  viewModel.report = emailReport

  return NavigationStack {
    EmailReportDetailScreen(viewModel: viewModel)
  }
}
