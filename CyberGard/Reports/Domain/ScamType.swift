enum ScamType: String, Identifiable, CaseIterable, Decodable {
  case extortionOrBlackmail = "Extortion / Blackmail"
  case fakeSupport = "Fake Support"
  case harassmentOrThreats = "Harassment / Threats"
  case impersonation = "Impersonation"
  case maliciousContent = "Malicious Content"
  case phishing = "Phishing"
  case scamOrFraud = "Scam / Fraud"
  case spamOrTelemarketing = "Spam / Telemarketing"
  case suspiciousLinkOrDomain = "Suspicious Link / Domain"
  case other = "Other (please specify)"

  var id: Self { self }

  static var `default`: Self {
    return .fakeSupport
  }
}

extension ScamType {
  var title: String {
    return switch self {
    case .extortionOrBlackmail:
      "Extortion / Blackmail"
    case .fakeSupport:
      "Fake Support"
    case .harassmentOrThreats:
      "Harassment / Threats"
    case .impersonation:
      "Impersonation"
    case .maliciousContent:
      "Malicious Content"
    case .phishing:
      "Phishing"
    case .scamOrFraud:
      "Scam / Fraud"
    case .spamOrTelemarketing:
      "Spam / Telemarketing"
    case .suspiciousLinkOrDomain:
      "Suspicious Link / Domain"
    case .other:
      "Other (please specify)"
    }
  }
}

extension ScamType {
  static var emailOnlyCases: [ScamType] {
    return [
      .fakeSupport,
      .extortionOrBlackmail,
      .harassmentOrThreats,
      .impersonation,
      .maliciousContent,
      .phishing,
      .scamOrFraud,
      .spamOrTelemarketing,
      .other,
    ]
  }

  static var phoneOnlyCases: [ScamType] {
    return [
      .fakeSupport,
      .harassmentOrThreats,
      .impersonation,
      .scamOrFraud,
      .spamOrTelemarketing,
      .other,
    ]
  }

  static var urlOnlyCases: [ScamType] {
    return [
      .fakeSupport,
      .impersonation,
      .maliciousContent,
      .phishing,
      .scamOrFraud,
      .suspiciousLinkOrDomain,
      .other,
    ]
  }
}
