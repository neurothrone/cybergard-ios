import SwiftUI

private struct EmailReportServiceKey: EnvironmentKey {
  static let defaultValue: EmailReportHandling = EmailReportInMemoryService()
}

private struct PhoneReportServiceKey: EnvironmentKey {
  static let defaultValue: PhoneReportHandling = PhoneReportInMemoryService()
}

private struct UrlReportServiceKey: EnvironmentKey {
  static let defaultValue: UrlReportHandling = UrlReportInMemoryService()
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
  
  var urlReportService: UrlReportHandling {
    get { self[UrlReportServiceKey.self] }
    set { self[UrlReportServiceKey.self] = newValue }
  }
}
