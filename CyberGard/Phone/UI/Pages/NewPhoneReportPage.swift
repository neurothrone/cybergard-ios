import SwiftUI

struct NewPhoneReportPage: View {
  @Environment(\.dismiss) private var dismiss

  @StateObject private var viewModel: NewPhoneReportViewModel

  @State private var showAlert = false
  @State private var alertTitle = ""
  @State private var alertMessage = ""

  init(viewModel: NewPhoneReportViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  var body: some View {
    Form {
      Section(header: Text("Report details")) {
        TextField("Phone number", text: $viewModel.phoneNumber)
          .keyboardType(.emailAddress)
          .autocapitalization(.none)
          .disableAutocorrection(true)
          .textContentType(.emailAddress)

        TextField("Country", text: $viewModel.country)
          .disableAutocorrection(true)
          .textContentType(.countryName)

        Picker("Scam Type", selection: $viewModel.scamType) {
          ForEach(ScamType.allCases) { scamType in
            Text(scamType.title)
              .tag(scamType)
          }
        }
        .pickerStyle(.menu)
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
            Text("Report Phone")
              .foregroundColor(viewModel.isValid ? .red : .gray)
          }
        }
        .disabled(!viewModel.isValid || viewModel.isLoading)
      }
    }
    .navigationTitle("Report Phone")
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
      alertMessage = "Phone reported successfully."
    } else {
      alertTitle = "Error"
      alertMessage = viewModel.error ?? "Unknown error."
    }

    showAlert = true
  }
}

#Preview {
  NavigationStack {
    NewPhoneReportPage(
      viewModel: NewPhoneReportViewModel(
        service: PhoneReportInMemoryService()
      )
    )
  }
}
