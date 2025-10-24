//
//  Category.swift
//  ofraud1
//
//  Created by Aislinn Gil on 16/10/25.
//

import Foundation

struct Category: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let slug: String
    let description: String?
    let isActive: Bool
    let reportsCount: Int
    let searchCount: Int
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case slug
        case description
        case isActive = "is_active"
        case reportsCount = "reports_count"
        case searchCount = "search_count"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
