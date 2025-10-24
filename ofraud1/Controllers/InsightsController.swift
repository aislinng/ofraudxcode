//
//  InsightsController.swift
//  ofraud1
//
//  Created by Aislinn Gil on 16/10/25.
//

import Foundation

struct InsightsController {
    let httpClient: HTTPClient

    func getFraudStats() async throws -> FraudStats {
        return try await httpClient.getFraudStats()
    }

    func getTopHosts(period: String = "weekly", limit: Int = 10) async throws -> [TopHost] {
        return try await httpClient.getTopHosts(period: period, limit: limit)
    }

    func getEducationalTopics() async throws -> [EducationalTopic] {
        return try await httpClient.getEducationalTopics()
    }

    func getEducationalContent(topic: String) async throws -> EducationalContent {
        return try await httpClient.getEducationalContent(topic: topic)
    }
}
