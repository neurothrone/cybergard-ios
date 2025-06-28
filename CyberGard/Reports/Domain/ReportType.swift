enum ReportType: String, Identifiable, Decodable, CaseIterable {
  case email
  case phone
  case url

  var id: Self { self }
}
