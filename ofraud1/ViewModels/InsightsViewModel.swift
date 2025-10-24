//
//  InsightsViewModel.swift
//  ofraud1
//
//  Created by Aislinn Gil on 16/10/25.
//

import Foundation

@MainActor
class InsightsViewModel: ObservableObject {
    @Published var fraudStats: FraudStats?
    @Published var topHosts: [TopHost] = []
    @Published var categories: [Category] = []
    @Published var educationalTopics: [EducationalTopic] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let insightsController = InsightsController(httpClient: HTTPClient())
    private let categoriesController = CategoriesController(httpClient: HTTPClient())

    func loadInsights() async {
        isLoading = true
        errorMessage = nil

        do {
            async let statsTask = insightsController.getFraudStats()
            async let hostsTask = insightsController.getTopHosts(period: "weekly", limit: 5)
            async let topicsTask = insightsController.getEducationalTopics()
            async let categoriesTask = categoriesController.getCategories()

            let (stats, hosts, topics, cats) = try await (statsTask, hostsTask, topicsTask, categoriesTask)

            fraudStats = stats
            topHosts = hosts
            educationalTopics = topics
            categories = cats
            isLoading = false
        } catch {
            errorMessage = "Error al cargar insights: \(error.localizedDescription)"
            isLoading = false
        }
    }
}
