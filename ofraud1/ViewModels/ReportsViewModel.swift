//
//  ReportsViewModel.swift
//  ofraud1
//
//  Created by Aislinn Gil on 16/10/25.
//

import Foundation

@MainActor
class ReportsViewModel: ObservableObject {
    @Published var reports: [ReportFeedItem] = []
    @Published var topHosts: [ReportsInsightsTopHost] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let reportsController = ReportsController(httpClient: HTTPClient())

    func loadReports() async {
        isLoading = true
        errorMessage = nil

        do {
            let response = try await reportsController.getReports()
            reports = response.feed
            topHosts = response.insights.topHosts
            isLoading = false
        } catch {
            errorMessage = "Error al cargar reportes: \(error.localizedDescription)"
            isLoading = false
        }
    }

    func refreshReports() async {
        await loadReports()
    }
}
