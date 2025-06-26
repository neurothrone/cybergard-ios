import SwiftUI

struct UrlReportDetailsSectionView: View {
  let report: UrlReportDetails

  var body: some View {
    Section {
      LabeledContent("Url", value: report.url)
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
    UrlReportDetailsSectionView(
      report: .sample
    )
  }
}
