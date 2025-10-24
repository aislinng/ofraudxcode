//
//  CreateReportRequest.swift
//  ofraud1
//
//  Created by Aislinn Gil on 16/10/25.
//

import Foundation

struct CreateReportMediaDTO: Codable {
    let fileUrl: String
    let mediaType: String  // "image" or "video"
    let position: Int?
}

struct CreateReportRequest: Codable {
    let categoryId: Int
    let title: String?
    let description: String
    let incidentUrl: String
    let isAnonymous: Bool?
    let publisherHost: String?
    let media: [CreateReportMediaDTO]
}

struct CreateReportResponse: Codable {
    let reportId: Int
    let revisionId: Int
}
