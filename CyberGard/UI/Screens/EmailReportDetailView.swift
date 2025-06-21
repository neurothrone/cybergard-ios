import SwiftUI

struct EmailReportDetailView: View {
  let report: EmailReport
  
  var body: some View {
    VStack {
      Text("Email Report Detail View")
      Text(report.email)
      Text(report.country)
    }
  }
}

#Preview {
  EmailReportDetailView(report: EmailReport.sample)
}
