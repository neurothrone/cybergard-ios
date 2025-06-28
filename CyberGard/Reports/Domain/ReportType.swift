import UIKit

enum ReportType: String, Identifiable, Decodable, CaseIterable {
  case email
  case phone
  case url

  var id: Self { self }
}

extension ReportType {
  func isValid(_ input: String) -> Bool {
    switch self {
    case .email: EmailValidator.isValidEmail(input)
    case .phone: PhoneValidator.isValidPhoneNumber(input)
    case .url: UrlValidator.isValidUrl(input)
    }
  }

  var keyboardType: UIKeyboardType {
    switch self {
    case .email:
      return .emailAddress
    case .phone:
      return .phonePad
    case .url:
      return .URL
    }
  }

  var textContentType: UITextContentType {
    switch self {
    case .email:
      return .emailAddress
    case .phone:
      return .telephoneNumber
    case .url:
      return .URL
    }
  }

  var systemImage: String {
    switch self {
    case .email:
      return "envelope"
    case .phone:
      return "phone"
    case .url:
      return "link"
    }
  }
}
