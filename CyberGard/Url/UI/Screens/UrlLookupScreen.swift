import SwiftUI

struct UrlLookupScreen: View {
  var body: some View {
    NavigationStack {
      VStack {
        Text("URL Lookup")
      }
      .navigationTitle("URL Lookup")
      .navigationBarTitleDisplayMode(.inline)
      .searchable(
        text: .constant(""),
        prompt: "Search by URL, scam, or country"
      )
    }
  }
}

#Preview {
  UrlLookupScreen()
}
