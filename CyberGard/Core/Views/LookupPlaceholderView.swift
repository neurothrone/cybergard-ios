import SwiftUI

struct LookupPlaceholderView: View {
  let icon: String
  let title: String
  let subtitle: String?

  var body: some View {
    VStack(spacing: 16) {
      Image(systemName: icon)
        .font(.system(size: 48))
        .foregroundColor(.secondary)
      Text(title)
        .foregroundColor(.secondary)
        .font(.title3)
      
      if let subtitle = subtitle {
        Text(subtitle)
          .foregroundColor(.secondary)
          .font(.body)
          .multilineTextAlignment(.center)
          .padding(.horizontal)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

#Preview {
  LookupPlaceholderView(
    icon: "envelope.open",
    title: "No email reports yet",
    subtitle: "Start by searching or reporting a suspicious email."
  )
}
