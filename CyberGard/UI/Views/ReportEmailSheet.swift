import SwiftUI

struct ReportEmailSheet: View {
  @StateObject private var viewModel: EmailReportDetailViewModel

  @State private var scamType: ScamType = .spamOrTelemarketing
  @State private var comment: String = ""

  @State private var isLoading = false
  @State private var showAlert = false
  @State private var alertTitle = ""
  @State private var alertMessage = ""

  init(viewModel: EmailReportDetailViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

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
    let commentToSend: String = (scamType == .other) ? comment : scamType.title
    let success = await viewModel.addComment(commentToSend)
    if success {
      alertTitle = "Success"
      alertMessage = "Email reported successfully."
    } else {
      alertTitle = "Error"
      alertMessage = viewModel.error ?? "Unknown error."
    }
    isLoading = false
    showAlert = true
  }
}

#Preview {
  ReportEmailSheet(
    viewModel: EmailReportDetailViewModel(
      email: EmailReport.sample.email,
      service: EmailReportInMemoryService()
    )
  )
}
