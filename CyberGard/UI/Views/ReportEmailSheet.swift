import SwiftUI

struct ReportEmailSheet: View {
  @Environment(\.emailReportService) private var emailReportService

  @State private var scamType: ScamType = .spamOrTelemarketing
  @State private var comment: String = ""
  
  @State private var isLoading = false
  @State private var showAlert = false
  @State private var alertTitle = ""
  @State private var alertMessage = ""

  let report: EmailReport

  var body: some View {
    Form {
      Section(header: Text("Report Email")) {
        Picker("Scam Type", selection: $scamType) {
          ForEach(ScamType.allCases) { scamType in
            Text(scamType.title)
              .tag(scamType)
          }
        }
        .pickerStyle(.menu)
      }

      if scamType == .other {
        Section(header: Text("Other Scam Type")) {
          ZStack(alignment: .topLeading) {
            if comment.isEmpty {
              Text("Please specify the scam type")
                .foregroundColor(.gray)
                .padding(.horizontal, 4)
                .padding(.top, 8)
            }

            TextEditor(text: $comment)
              .frame(height: 150)
          }
        }
      }

      Section {
        Button {
          Task { await reportEmail() }
        } label: {
          if isLoading {
            ProgressView()
          } else {
            Text("Report Email")
              .foregroundColor(isFormValid ? .red : .gray)
          }
        }
        .disabled(!isFormValid || isLoading)
      }
    }
    .alert(alertTitle, isPresented: $showAlert) {
      Button("OK", role: .cancel) {}
    } message: {
      Text(alertMessage)
    }
  }

  private var isFormValid: Bool {
    if scamType == .other {
      return !comment.isEmpty
    }
    return true
  }

  private func reportEmail() async {
    isLoading = true
    let comment: String
    if scamType == .other {
      comment = self.comment
    } else {
      comment = scamType.title
    }
    do {
      try await Task.sleep(for: .seconds(1))  // simulate network delay
      //throw URLError(.badURL) // simulate network error for testing
      let updatedReport =
        try await emailReportService.addCommentToEmailReportAsync(
          email: report.email,
          comment: comment
        )
      alertTitle = "Success"
      if updatedReport != nil {
        alertMessage = "Email reported successfully."
      } else {
        alertMessage = "Email report updated with new comment."
      }
    } catch {
      alertTitle = "Error"
      alertMessage = "Failed to report email: \(error.localizedDescription)"
    }
    isLoading = false
    showAlert = true
  }
}

#Preview {
  ReportEmailSheet(report: EmailReport.sample)
    .environment(\.emailReportService, EmailReportInMemoryService())
}
