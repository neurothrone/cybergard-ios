struct SearchReportResponse: Decodable {
  let items: [ReportItem]
  let totalCount: Int

  enum CodingKeys: String, CodingKey {
    case items = "items"
    case totalCount = "total-count"
  }
}
