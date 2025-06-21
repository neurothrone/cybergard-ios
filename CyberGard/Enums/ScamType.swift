import Foundation

enum ScamType: Identifiable, CaseIterable {
  case spamOrTelemarketing
  case scamOrFraud
  case wrongNumber
  case harassment
  case other

  var id: Self { self }

  static var `default`: Self {
    return .spamOrTelemarketing
  }

  var title: String {
    switch self {
    case .spamOrTelemarketing:
      return "Spam / Telemarketing"
    case .scamOrFraud:
      return "Scam / Fraud"
    case .wrongNumber:
      return "Wrong Number"
    case .harassment:
      return "Harassment"
    case .other:
      return "Other (please specify)"
    }
  }
}
