//
//  ReportDetail.swift
//  ofraud1
//
//  Created by Aislinn Gil on 16/10/25.
//

import Foundation

struct ReportDetailCategory: Codable, Hashable {
    let id: Int
    let name: String?
    let slug: String?
}

struct ReportDetailAuthor: Codable, Hashable {
    let isAnonymous: Bool
    let authorId: Int?
    let displayName: String?
}

struct ReportDetailMedia: Codable, Identifiable, Hashable {
    let mediaId: Int
    let fileUrl: String
    let mediaType: String?
    let position: Int

    var id: Int { mediaId }
}

struct ReportDetail: Codable, Identifiable, Hashable {
    let reportId: Int
    let title: String?
    let description: String
    let incidentUrl: String
    let publisherHost: String
    let createdAt: String
    let approvedAt: String?
    let publishedAt: String?
    let category: ReportDetailCategory?
    let author: ReportDetailAuthor
    let media: [ReportDetailMedia]
    let ratingAverage: Double
    let ratingCount: Int

    var id: Int { reportId }
}
