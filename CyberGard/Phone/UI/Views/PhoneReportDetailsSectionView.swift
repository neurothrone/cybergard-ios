import SwiftUI

struct PhoneReportDetailsSectionView: View {
  let report: PhoneReportDetails

  var body: some View {
    Section {
      LabeledContent("Phone number", value: report.phoneNumber)
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
    PhoneReportDetailsSectionView(
      report: .sample
    )
  }
}
