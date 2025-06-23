import SwiftUI

struct UrlLookupPage: View {
  var body: some View {
    NavigationStack {
      VStack {
        Text("URL Lookup")
      }
      .navigationTitle("URL Lookup")
      .navigationBarTitleDisplayMode(.inline)
      .searchable(
        text: .constant(""),
        placement: .navigationBarDrawer(displayMode: .always),
        prompt: "Search by URL, scam, or country"
      )
    }
  }
}

#Preview {
  UrlLookupPage()
}
