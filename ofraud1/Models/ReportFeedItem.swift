//
//  ReportFeedItem.swift
//  ofraud1
//
//  Created by Aislinn Gil on 16/10/25.
//

import Foundation

struct ReportFeedItem: Codable, Identifiable, Hashable {
    let reportId: Int
    let categoryId: Int
    let categoryName: String?
    let categorySlug: String?
    let title: String?
    let description: String
    let incidentUrl: String
    let publisherHost: String
    let ratingAverage: Double
    let ratingCount: Int
    let publishedAt: String?
    let approvedAt: String?
    let author: ReportDetailAuthor
    let media: [ReportDetailMedia]

    var id: Int { reportId }
}
