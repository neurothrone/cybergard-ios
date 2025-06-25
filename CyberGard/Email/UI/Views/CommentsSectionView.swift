import SwiftUI

struct CommentsSectionView: View {
  let comments: [Comment]

  var body: some View {
    Section {
      ForEach(comments, id: \.postedDate) { comment in
        CommentCellView(comment: comment)
          .listRowBackground(Color.blue.opacity(0.1))
      }
    } header: {
      Text("Comments (\(Text("\(comments.count)").bold()))")
    }
  }
}

#Preview {
  List {
    CommentsSectionView(
      comments: EmailReportDetails.sample.comments
    )
  }
}
