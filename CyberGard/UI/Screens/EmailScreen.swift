import SwiftUI

struct EmailScreen: View {
  @Environment(\.emailReportService) private var emailReportService
  
  @State private var reports: [EmailReport] = []
  @State private var isLoading = false
  @State private var loadError: String?

  var body: some View {
    NavigationStack {
      VStack {
        if isLoading {
          ProgressView("Loading Reports...")
        } else if let error = loadError {
          Text(error)
            .foregroundColor(.red)
            .padding()
        } else {
          List(reports, id: \.email) { report in
            NavigationLink(destination: EmailReportDetailScreen(report: report)) {
              EmailReportCellView(report: report)
            }
          }
          .refreshable {
            await loadReports(isRefresh: true)
          }
        }
      }
      .navigationTitle("Email Reports")
      .task {
        if reports.isEmpty {
          await loadReports()
        }
      }
    }
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
