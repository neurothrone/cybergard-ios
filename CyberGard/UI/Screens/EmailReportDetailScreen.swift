import SwiftUI

struct EmailReportDetailScreen: View {
  @Environment(\.emailReportService) private var emailReportService

  @State private var isReporting = false

  let report: EmailReport

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

      VStack(alignment: .leading, spacing: 4) {
        Text(report.email)
          .bold()
        Text("Scam Type: \(report.scamType)")
        Text("Country: \(report.country)")
        Text("Reported: \(report.reportedDate.formattedDateTime24h)")
        Text("Reports: \(report.reports.count)")
      }
      .padding(20)

      List {
        Section(header: Text("Comments")) {
          ForEach(report.reports, id: \.date) { reportItem in
            CommentCellView(reportItem: reportItem)
              .listRowBackground(Color.blue.opacity(0.1))
          }
        }
      }
    }
    .navigationTitle("Email Report")
    .navigationBarTitleDisplayMode(.inline)
    .sheet(isPresented: $isReporting) {
      ReportEmailSheet(report: report)
    }
  }
}

#Preview {
  NavigationStack {
    EmailReportDetailScreen(report: EmailReport.sample)
  }
  .environment(\.emailReportService, EmailReportInMemoryService())
}
