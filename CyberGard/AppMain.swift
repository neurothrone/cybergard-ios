import SwiftUI

@main
struct AppMain: App {
  let environment: ApiEnvironment = .development

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.reportService, ReportApiService(baseURL: environment.baseURL))
    }
  }
}
