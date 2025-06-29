import SwiftUI

struct AddCommentSheet: View {
  @Environment(\.dismiss) private var dismiss

  @StateObject private var viewModel: ReportDetailViewModel

  @State private var showAlert = false
  @State private var alertTitle = ""
  @State private var alertMessage = ""

  init(viewModel: ReportDetailViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    Form {
      Section(header: Text("Report Email")) {
        ScamTypePickerView(
          scamType: $viewModel.scamType,
          scamTypeChoices: ScamType.emailOnlyCases
        )
      }

      if viewModel.scamType == .other {
        Section(header: Text("Other Scam Type")) {
          ZStack(alignment: .topLeading) {
            if viewModel.comment.isEmpty {
              Text("Please specify the scam type")
                .foregroundColor(.gray)
                .padding(.horizontal, 4)
                .padding(.top, 8)
            }

            TextEditor(text: $viewModel.comment)
              .frame(height: 150)
          }
        }
      }

      Section {
        Button {
          Task { await reportEmail() }
        } label: {
          if viewModel.isLoading {
            ProgressView()
          } else {
            Text("Report Email")
              .foregroundColor(viewModel.isValid ? .red : .gray)
          }
        }
        .disabled(!viewModel.isValid || viewModel.isLoading)
      }
    }
    .alert(alertTitle, isPresented: $showAlert) {
      Button("OK", role: .cancel) {
        if viewModel.error == nil {
          dismiss()
        }
      }
    } message: {
      Text(alertMessage)
    }
  }

  private func reportEmail() async {
    let success = await viewModel.addComment()

    if success {
      alertTitle = "Success"
      alertMessage = "Email reported successfully."
    } else {
      alertTitle = "Error"
      alertMessage = viewModel.error ?? "Unknown error."
    }

    showAlert = true
  }
}

#Preview {
  AddCommentSheet(
    viewModel: ReportDetailViewModel(
      reportType: .email,
      identifier: ReportDetails.sample.identifier,
      service: ReportPreviewService()
    )
  )
}
