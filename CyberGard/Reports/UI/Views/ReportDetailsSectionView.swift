import SwiftUI

struct ReportDetailsSectionView: View {
  let report: ReportDetails

  var body: some View {
    Section("Details") {
      LabeledContent(report.reportType.rawValue, value: report.identifier)
      LabeledContent("Scam", value: report.scamType.rawValue)
      LabeledContent("Country", value: report.country)
      LabeledContent("Reports", value: report.comments.count.description)
    }
  }
}

#Preview {
  List {
    ReportDetailsSectionView(
      report: ReportDetails.sample
    )
  }
}
