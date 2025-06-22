import SwiftUI

struct CommentCellView: View {
  let comment: Comment

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Text("Anonymous")
          .font(.headline)
          .fontWeight(.bold)

        Spacer()

        Text(comment.postedDate.formattedDateTime24h)
          .foregroundStyle(.secondary)
          .fontWeight(.semibold)
      }

      Text(comment.text)
    }
  }
}

#Preview {
  List(0..<5) { _ in
    CommentCellView(comment: Comment.sample)
  }
}
