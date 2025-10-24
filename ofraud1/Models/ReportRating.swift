//
//  ReportRating.swift
//  ofraud1
//
//  Created by Aislinn Gil  on 23/10/25.
//

import Foundation

struct CreateReportRatingRequest: Codable {
    let score: Int  // 1-5
    let comment: String?
}

struct UpdateReportRatingRequest: Codable {
    let score: Int  // 1-5
    let comment: String?
}

struct ReportRatingResponse: Codable {
    let ratingId: Int
    let reportId: Int
    let userId: Int
    let score: Int
    let comment: String?
    let createdAt: String
    let updatedAt: String?
}
