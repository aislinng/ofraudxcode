//
//  MyReport.swift
//  ofraud1
//
//  Created by Aislinn Gil on 16/10/25.
//

import Foundation

enum ReportStatus: String, Codable {
    case pending = "pending"
    case approved = "approved"
    case rejected = "rejected"
    case removed = "removed"
}

struct MyReportItem: Codable, Identifiable, Hashable {
    let reportId: Int
    let title: String?
    let status: ReportStatus
    let categoryId: Int
    let categoryName: String?
    let createdAt: String
    let lastEditedAt: String?
    let updatedAt: String

    var id: Int { reportId }
}

struct MyReportsMeta: Codable {
    let page: Int
    let limit: Int
    let total: Int
}

struct GetMyReportsResponse: Codable {
    let items: [MyReportItem]
    let meta: MyReportsMeta
}
