import SwiftUI

struct UrlReportCellView: View {
  let report: UrlReport

  var body: some View {
    HStack {
      Image(systemName: "phone")
        .foregroundColor(.blue)

      VStack(alignment: .leading) {
        Text(report.url)
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
    UrlReportCellView(
      report: UrlReport.sample
    )
  }
}
