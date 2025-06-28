import SwiftUI

struct ScamTypePickerView: View {
  @Binding var scamType: ScamType
  let scamTypeChoices: [ScamType]

  var body: some View {
    Picker("Scam Type", selection: $scamType) {
      ForEach(scamTypeChoices) { scamType in
        Text(scamType.title)
          .tag(scamType)
      }
    }
    .pickerStyle(.menu)
  }
}

#Preview {
  ScamTypePickerView(
    scamType: .constant(.default),
    scamTypeChoices: ScamType.emailOnlyCases
  )
}
