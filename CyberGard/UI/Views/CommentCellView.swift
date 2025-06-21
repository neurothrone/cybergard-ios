import SwiftUI

struct CommentCellView: View {
  let reportItem: ReportItem
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Text("Anonymous")
          .font(.headline)
          .fontWeight(.bold)
        
        Spacer()
        
        Text(reportItem.date.formattedDateTime24h)
          .foregroundStyle(.secondary)
          .fontWeight(.semibold)
      }
      
      Text(reportItem.comment)
    }
  }
}

#Preview {
  List(0 ..< 5) { item in
    CommentCellView(reportItem: ReportItem.sample)
  }
}
