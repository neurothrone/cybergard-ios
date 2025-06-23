import SwiftUI

struct PhoneLookupPage: View {
  var body: some View {
    NavigationStack {
      VStack {
        Text("Phone Lookup")
      }
      .navigationTitle("Phone Lookup")
      .navigationBarTitleDisplayMode(.inline)
      .searchable(
        text: .constant(""),
        placement: .navigationBarDrawer(displayMode: .always),
        prompt: "Search by phone, scam, or country"
      )
    }
  }
}

#Preview {
  PhoneLookupPage()
}
