import SwiftUI

struct ReportTypePickerView: View {
  @Binding var reportType: ReportType

  var body: some View {
    Picker("Report Type", selection: $reportType) {
      ForEach(ReportType.allCases) { type in
        Text(type.rawValue.capitalized)
          .tag(type)
      }
    }
    .pickerStyle(.menu)
  }
}

#Preview {
  ReportTypePickerView(
    reportType: .constant(.default)
  )
}
