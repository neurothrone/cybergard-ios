import Foundation

struct PhoneValidator {
  static func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
    let phoneRegex = "^\\+?[0-9]{7,15}$"
    return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phoneNumber)
  }
}
