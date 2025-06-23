import SwiftUI

struct SettingsScreen: View {
  var body: some View {
    NavigationStack {
      Form {
        Section(header: Text("General")) {
          NavigationLink(destination: Text("Profile Settings")) {
            Text("Profile")
          }

          NavigationLink(destination: Text("Notifications Settings")) {
            Text("Notifications")
          }

          NavigationLink(destination: Text("Privacy Settings")) {
            Text("Privacy")
          }
        }

        Section(header: Text("Support")) {
          NavigationLink(destination: Text("Help & Support")) {
            Text("Help & Support")
          }

          NavigationLink(destination: Text("About Us")) {
            Text("About Us")
          }
        }
      }
      .navigationTitle("Settings")
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

#Preview {
  SettingsScreen()
}
