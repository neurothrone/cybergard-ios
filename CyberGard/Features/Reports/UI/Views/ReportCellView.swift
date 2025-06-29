import SwiftUI

struct ReportCellView: View {
  let report: ReportItem

  var body: some View {
    HStack {
      Image(systemName: report.reportType.systemImage)
        .foregroundColor(.blue)

      VStack(alignment: .leading) {
        Text(report.identifier)
          .font(.headline)
          .fontWeight(.semibold)
          .lineLimit(1)
          .truncationMode(.tail)
        Text(report.country)
      }

      Spacer()

      Text("\(report.commentsCount) reports")
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
    ReportCellView(
      report: ReportItem.sample
    )
  }
}
