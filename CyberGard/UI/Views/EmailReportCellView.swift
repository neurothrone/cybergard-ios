import SwiftUI

struct EmailReportCellView: View {
  let report: EmailReport
  
  var body: some View {
    HStack {
      Image(systemName: "envelope")
        .foregroundColor(.blue)
      
      VStack(alignment: .leading) {
        Text(report.email)
          .font(.headline)
          .fontWeight(.semibold)
          .lineLimit(1)
          .truncationMode(.tail)
        Text(report.country)
      }
      
      Spacer()
      
      Text("\(report.reports.count) reports")
        .fontWeight(.semibold)
        .foregroundColor(.primary)
        .padding(8)
        .background(Color.gray.opacity(0.3))
        .clipShape(.rect(cornerRadius: 8))
    }
  }
}

#Preview {
  List {
    EmailReportCellView(report: EmailReport.sample)
  }
}
