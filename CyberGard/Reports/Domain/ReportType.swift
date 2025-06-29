import UIKit

enum ReportType: String, Identifiable, Decodable, CaseIterable {
  case email
  case phone
  case url

  var id: Self { self }
}

extension ReportType {
  static var `default`: Self { .email }

  func isValid(_ input: String) -> Bool {
    switch self {
    case .email: EmailValidator.isValidEmail(input)
    case .phone: PhoneValidator.isValidPhoneNumber(input)
    case .url: UrlValidator.isValidUrl(input)
    }
  }

  var keyboardType: UIKeyboardType {
    switch self {
    case .email: .emailAddress
    case .phone: .phonePad
    case .url: .URL
    }
  }

  var textContentType: UITextContentType {
    switch self {
    case .email: .emailAddress
    case .phone: .telephoneNumber
    case .url: .URL
    }
  }

  var systemImage: String {
    switch self {
    case .email: "envelope"
    case .phone: "phone"
    case .url: "link"
    }
  }
}
