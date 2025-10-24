//
//  URL.swift
//  ofraud1
//
//  Created by Aislinn Gil on 07/10/25.
//

import Foundation

struct URLEndpoints {
    static var server: String = "http://localhost:3000"

    // MARK: - Auth Endpoints
    static let login: String = String(server + "/auth/login")
    static let register: String = String(server + "/users")

    // MARK: - Reports Endpoints
    static let reports: String = String(server + "/reports")
    static let myReports: String = String(server + "/reports/mine")
    static func reportDetail(id: Int) -> String { String(server + "/reports/\(id)") }

    // MARK: - Categories Endpoints
    static let categories: String = String(server + "/categories")

    // MARK: - Insights Endpoints
    static let fraudStats: String = String(server + "/insights/fraud-stats")
    static func topHosts(period: String = "weekly", limit: Int = 10) -> String {
        String(server + "/insights/top-hosts?period=\(period)&limit=\(limit)")
    }
    static func topCategories(limit: Int = 10) -> String {
        String(server + "/insights/top-categories?limit=\(limit)")
    }
    static let educationalTopics: String = String(server + "/insights/educational")
    static func educationalContent(topic: String) -> String {
        String(server + "/insights/educational/\(topic)")
    }

    // MARK: - Files Endpoints
    static let uploadFile: String = String(server + "/files/upload")
}
