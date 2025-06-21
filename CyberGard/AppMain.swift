import SwiftUI

@main
struct AppMain: App {
  private let emailReportService: EmailReportHandling = EmailReportApiService()
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.emailReportService, emailReportService)
    }
  }
}
