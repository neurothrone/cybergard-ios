import SwiftUI

struct HomePage: View {
  var body: some View {
    NavigationStack {
      VStack(alignment: .center, spacing: 8) {
        Group {
          Text("CyberGard")
            .font(.largeTitle)
          Text(
            "Your trusted source for safety of phone numbers, emails, URLs, and more."
          )
          .font(.title3)
          Text(
            "This app is currently under construction. Stay tuned for updates!"
          )
          .font(.callout)
        }
        .multilineTextAlignment(.center)
      }
      .navigationTitle("Home")
      .navigationBarTitleDisplayMode(.inline)
      .frame(maxWidth: UIScreen.main.bounds.width * 0.9)
    }
  }
}

#Preview {
  HomePage()
}
