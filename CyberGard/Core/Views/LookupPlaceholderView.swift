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
    title: "Search or report a suspicious email",
    subtitle: "Use the search bar above or tap the flag to report a new email."
  )
}
