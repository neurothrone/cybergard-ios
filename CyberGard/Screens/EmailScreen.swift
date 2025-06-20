import SwiftUI

struct EmailScreen: View {
  @State private var reports: [EmailReport]
  @State private var isLoading = false
  @State private var loadError: String?

  init(reports: [EmailReport] = []) {
    _reports = State(initialValue: reports)
  }

  var body: some View {
    VStack {
      if isLoading {
        ProgressView("Loading Reports...")
      } else if let error = loadError {
        Text(error)
          .foregroundColor(.red)
          .padding()
      } else {
        List(reports, id: \.email) { report in
          VStack(alignment: .leading) {
            Text(report.email)
              .bold()
            Text("Scam Type: \(report.scamType)")
            Text("Country: \(report.country)")
            Text("Reported: \(report.reportedDate.formattedDateTime24h)")
          }
          .padding(.vertical, 4)
        }
        .refreshable {
          await loadReports(isRefresh: true)
        }
      }
    }
    .task {
      if reports.isEmpty {
        await loadReports()
      }
    }
  }

  private func loadReports(isRefresh: Bool = false) async {
    if !isRefresh {
      isLoading = true
    }
    loadError = nil
    
    do {
      try await Task.sleep(nanoseconds: 1_000_000_000) // simulate delay
      let repo = EmailReportService()
      reports = try await repo.getAllAsync()
    } catch {
      loadError = "Failed to fetch reports: \(error.localizedDescription)"
    }
    
    if !isRefresh {
      isLoading = false
    }
  }
}

#Preview {
  EmailScreen(reports: EmailReport.samples)
}

private extension Date {
  var formattedDateTime24h: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone.current
    return formatter.string(from: self)
  }
}
