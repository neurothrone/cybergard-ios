import SwiftUI

struct EmailScreen: View {
  @Environment(\.emailReportService) private var emailReportService
  
  @State private var reports: [EmailReport] = []
  @State private var isLoading = false
  @State private var loadError: String?

  @State private var selectedReport: EmailReport? = nil

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
          .onTapGesture {
            selectedReport = report
          }
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
    .sheet(item: $selectedReport, content: EmailReportDetailView.init)
  }

  private func loadReports(isRefresh: Bool = false) async {
    if !isRefresh {
      isLoading = true
    }
    loadError = nil

    do {
      try await Task.sleep(for: .seconds(1)) // simulate network delay
      reports = try await emailReportService.getAllAsync()
    } catch {
      loadError = "Failed to fetch reports: \(error.localizedDescription)"
    }

    if !isRefresh {
      isLoading = false
    }
  }
}

#Preview {
  EmailScreen()
    .environment(\.emailReportService, EmailReportInMemoryService())
}
