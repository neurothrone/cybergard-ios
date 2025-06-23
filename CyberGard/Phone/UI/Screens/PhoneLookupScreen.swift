import SwiftUI

struct PhoneLookupScreen: View {
  var body: some View {
    NavigationStack {
      VStack {
        Text("Phone Lookup")
      }
      .navigationTitle("Phone Lookup")
      .navigationBarTitleDisplayMode(.inline)
      .searchable(
        text: .constant(""),
        prompt: "Search by phone, scam, or country"
      )
    }
  }
}

#Preview {
  PhoneLookupScreen()
}
