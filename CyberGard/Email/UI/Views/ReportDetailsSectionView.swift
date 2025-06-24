import SwiftUI

struct ReportDetailsSectionView: View {
  let report: EmailReportDetails

  var body: some View {
    Section {
      LabeledContent("Email", value: report.email)
      LabeledContent("Scam", value: report.scamType)
      LabeledContent("Country", value: report.country)
      LabeledContent("Reports", value: report.commentsCount.description)
    } header: {
      Text("Details")
    }
  }
}

#Preview {
  List {
    ReportDetailsSectionView(report: .sample)
  }
}
