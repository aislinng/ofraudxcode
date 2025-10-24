//
//  ReportsController.swift
//  ofraud1
//
//  Created by Aislinn Gil on 16/10/25.
//

import Foundation

struct ReportsController {
    let httpClient: HTTPClient

    func getReports() async throws -> GetReportsResponse {
        return try await httpClient.getReports()
    }

    func getReportDetail(id: Int) async throws -> ReportDetail {
        return try await httpClient.getReportDetail(id: id)
    }

    func getMyReports() async throws -> GetMyReportsResponse {
        return try await httpClient.getMyReports()
    }

    func createReport(report: CreateReportRequest) async throws -> CreateReportResponse {
        return try await httpClient.createReport(report: report)
    }

    func createReportRating(reportId: Int, request: CreateReportRatingRequest) async throws -> ReportRatingResponse {
        return try await httpClient.createReportRating(reportId: reportId, request: request)
    }

    func updateReportRating(reportId: Int, ratingId: Int, request: UpdateReportRatingRequest) async throws -> ReportRatingResponse {
        return try await httpClient.updateReportRating(reportId: reportId, ratingId: ratingId, request: request)
    }

    func deleteReportRating(reportId: Int, ratingId: Int) async throws -> Bool {
        return try await httpClient.deleteReportRating(reportId: reportId, ratingId: ratingId)
    }
}
