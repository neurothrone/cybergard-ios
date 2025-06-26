import SwiftUI

private struct EmailReportServiceKey: EnvironmentKey {
  static let defaultValue: EmailReportHandling = EmailReportInMemoryService()
}

private struct PhoneReportServiceKey: EnvironmentKey {
  static let defaultValue: PhoneReportHandling = PhoneReportInMemoryService()
}

extension EnvironmentValues {
  var emailReportService: EmailReportHandling {
    get { self[EmailReportServiceKey.self] }
    set { self[EmailReportServiceKey.self] = newValue }
  }

  var phoneReportService: PhoneReportHandling {
    get { self[PhoneReportServiceKey.self] }
    set { self[PhoneReportServiceKey.self] = newValue }
  }
}
