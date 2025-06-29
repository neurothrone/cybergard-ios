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
}

extension ScamType {
  static var `default`: Self { .fakeSupport }

  var title: String {
    switch self {
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
  static func casesFor(_ type: ReportType) -> [ScamType] {
    switch type {
    case .email: emailOnlyCases
    case .phone: phoneOnlyCases
    case .url: urlOnlyCases
    }
  }

  static var emailOnlyCases: [ScamType] {
    [
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
    [
      .fakeSupport,
      .harassmentOrThreats,
      .impersonation,
      .scamOrFraud,
      .spamOrTelemarketing,
      .other,
    ]
  }

  static var urlOnlyCases: [ScamType] {
    [
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
