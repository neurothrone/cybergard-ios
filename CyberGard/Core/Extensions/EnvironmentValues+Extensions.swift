import SwiftUI

private struct ReportServiceKey: EnvironmentKey {
  static let defaultValue: ReportHandling = ReportApiService(
    baseURL: ApiEnvironment.development.baseURL
  )
}

extension EnvironmentValues {
  var reportService: ReportHandling {
    get { self[ReportServiceKey.self] }
    set { self[ReportServiceKey.self] = newValue }
  }
}
