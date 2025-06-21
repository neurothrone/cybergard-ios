import SwiftUI

private struct EmailReportServiceKey: EnvironmentKey {
    static let defaultValue: EmailReportHandling = EmailReportInMemoryService()
}

extension EnvironmentValues {
    var emailReportService: EmailReportHandling {
        get { self[EmailReportServiceKey.self] }
        set { self[EmailReportServiceKey.self] = newValue }
    }
}