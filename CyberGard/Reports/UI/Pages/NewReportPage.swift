import SwiftUI

struct NewReportPage: View {
  @Environment(\.dismiss) private var dismiss

  @StateObject private var viewModel: NewReportViewModel

  @State private var showAlert = false
  @State private var alertTitle = ""
  @State private var alertMessage = ""

  init(viewModel: NewReportViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    Form {
      Section(header: Text("Report details")) {
        ReportTypePickerView(reportType: $viewModel.reportType)

        TextField(
          viewModel.reportType.rawValue.capitalized,
          text: $viewModel.identifier
        )
        .autocapitalization(.none)
        .disableAutocorrection(true)
        .keyboardType(viewModel.reportType.keyboardType)
        .textContentType(viewModel.reportType.textContentType)

        TextField("Country", text: $viewModel.country)
          .disableAutocorrection(true)
          .textContentType(.countryName)

        ScamTypePickerView(
          scamType: $viewModel.scamType,
          scamTypeChoices: ScamType.casesFor(viewModel.reportType)
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
            Text("Report \(viewModel.reportType.rawValue.capitalized)")
              .foregroundColor(viewModel.isValid ? .red : .gray)
          }
        }
        .disabled(!viewModel.isValid || viewModel.isLoading)
      }
    }
    .navigationTitle("New Report")
    .navigationBarTitleDisplayMode(.inline)
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
    let success = await viewModel.addNewReport()

    if success {
      alertTitle = "Success"
      alertMessage = "\(viewModel.reportType.rawValue.capitalized) reported successfully."
    } else {
      alertTitle = "Error"
      alertMessage = viewModel.error ?? "Unknown error."
    }

    showAlert = true
  }
}

#Preview {
  NavigationStack {
    NewReportPage(
      viewModel: NewReportViewModel(
        service: ReportPreviewService()
      )
    )
  }
}
