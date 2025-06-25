import SwiftUI

struct NoSearchResultsView: View {
  var body: some View {
    VStack(spacing: 16) {
      Image(systemName: "magnifyingglass")
        .font(.system(size: 48))
        .foregroundColor(.secondary)
      Text("No results found")
        .foregroundColor(.secondary)
        .font(.title3)
    }
  }
}

#Preview {
  NoSearchResultsView()
}
