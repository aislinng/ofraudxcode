//
//  GetReportsResponse.swift
//  ofraud1
//
//  Created by Aislinn Gil on 16/10/25.
//

import Foundation

struct ReportsInsightsTopHost: Codable, Identifiable, Hashable {
    let host: String
    let reportCount: Int
    let averageRating: Double?
    let totalRatings: Int

    var id: String { host }
}

struct ReportsInsights: Codable, Hashable {
    let topHosts: [ReportsInsightsTopHost]
}

struct GetReportsResponse: Codable, Hashable {
    let feed: [ReportFeedItem]
    let insights: ReportsInsights
}
