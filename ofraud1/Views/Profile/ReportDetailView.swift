//
//  ReportDetailView.swift
//  ofraud1
//
//  Created by Aislinn Gil  on 16/10/25.
//

import SwiftUI

struct ReportDetailView: View {
    let reportId: Int

    @StateObject private var viewModel = ReportDetailViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showRatingSheet = false

    var body: some View {
        ZStack {
            Color.systemBackground.ignoresSafeArea()

            if viewModel.isLoading {
                ProgressView("Cargando detalles...")
            } else if let errorMessage = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text(errorMessage)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    Button("Reintentar") {
                        Task {
                            await viewModel.loadReportDetail(id: reportId)
                        }
                    }
                    .buttonStyle(.styled)
                }
                .padding()
            } else if let report = viewModel.report {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Category badge
                        if let category = report.category {
                            Text(category.name?.uppercased() ?? "")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.brandPrimary)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.brandPrimary.opacity(0.1))
                                .cornerRadius(4)
                        }

                        // Title
                        if let title = report.title {
                            Text(title)
                                .font(.title.bold())
                                .foregroundColor(.primary)
                        }

                        // Description
                        Text(report.description)
                            .font(.body)
                            .foregroundColor(.primary)

                        // Incident URL
                        VStack(alignment: .leading, spacing: 8) {
                            Text("URL del incidente:")
                                .font(.headline)
                            Link(report.incidentUrl, destination: URL(string: report.incidentUrl)!)
                                .font(.body)
                                .foregroundColor(.brandPrimary)
                        }

                        // Publisher Host
                        HStack {
                            Image(systemName: "link")
                            Text(report.publisherHost)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        // Author info
                        HStack {
                            Image(systemName: report.author.isAnonymous ? "person.fill.questionmark" : "person.fill")
                            Text(report.author.isAnonymous ? "Anónimo" : report.author.displayName ?? "Usuario")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        // Rating general
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Calificación General")
                                .font(.headline)

                            HStack {
                                HStack(spacing: 2) {
                                    ForEach(0..<5) { index in
                                        Image(systemName: index < Int(report.ratingAverage.rounded()) ? "star.fill" : "star")
                                            .font(.title3)
                                            .foregroundColor(.yellow)
                                    }
                                }
                                Text("\(report.ratingAverage, specifier: "%.1f")")
                                    .font(.headline)
                                Text("(\(report.ratingCount) calificaciones)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }

                        // User rating section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Tu Calificación")
                                .font(.headline)

                            if let userRating = viewModel.userRating {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        HStack(spacing: 2) {
                                            ForEach(0..<5) { index in
                                                Image(systemName: index < userRating.score ? "star.fill" : "star")
                                                    .font(.title3)
                                                    .foregroundColor(.yellow)
                                            }
                                        }
                                        Text("\(userRating.score)/5")
                                            .font(.subheadline.bold())

                                        Spacer()

                                        Button("Editar") {
                                            showRatingSheet = true
                                        }
                                        .font(.subheadline)
                                        .foregroundColor(.brandPrimary)
                                    }

                                    if let comment = userRating.comment, !comment.isEmpty {
                                        Text(comment)
                                            .font(.body)
                                            .foregroundColor(.secondary)
                                            .padding()
                                            .background(Color(.systemGray6))
                                            .cornerRadius(8)
                                    }
                                }
                                .padding()
                                .background(Color.brandPrimary.opacity(0.05))
                                .cornerRadius(12)
                            } else {
                                Button(action: { showRatingSheet = true }) {
                                    HStack {
                                        Image(systemName: "star.fill")
                                        Text("Calificar este reporte")
                                            .font(.headline)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.brandPrimary)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                                }
                            }
                        }

                        // Media gallery
                        if !report.media.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Evidencia")
                                    .font(.headline)

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(report.media.sorted(by: { $0.position < $1.position })) { media in
                                            AsyncImage(url: URL(string: media.fileUrl)) { phase in
                                                switch phase {
                                                case .empty:
                                                    ProgressView()
                                                        .frame(width: 200, height: 200)
                                                case .success(let image):
                                                    image
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 200, height: 200)
                                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                                case .failure:
                                                    Image(systemName: "photo")
                                                        .font(.largeTitle)
                                                        .foregroundColor(.gray)
                                                        .frame(width: 200, height: 200)
                                                        .background(Color.gray.opacity(0.2))
                                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                                @unknown default:
                                                    EmptyView()
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        // Dates
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Información adicional")
                                .font(.headline)

                            if let publishedAt = report.publishedAt {
                                HStack {
                                    Image(systemName: "calendar")
                                    Text("Publicado: \(formatDate(publishedAt))")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }

                            if let approvedAt = report.approvedAt {
                                HStack {
                                    Image(systemName: "checkmark.seal")
                                    Text("Aprobado: \(formatDate(approvedAt))")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Detalle del Reporte")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showRatingSheet) {
            RatingSheet(
                isPresented: $showRatingSheet,
                reportId: reportId,
                existingRating: viewModel.userRating,
                onSubmit: { rating, comment in
                    await viewModel.submitRating(reportId: reportId, score: rating, comment: comment)
                },
                onDelete: viewModel.userRating != nil ? {
                    await viewModel.deleteRating(reportId: reportId)
                } : nil
            )
        }
        .task {
            await viewModel.loadReportDetail(id: reportId)
        }
    }

    private func formatDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: dateString) else {
            return dateString
        }

        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        displayFormatter.timeStyle = .short
        return displayFormatter.string(from: date)
    }
}

@MainActor
class ReportDetailViewModel: ObservableObject {
    @Published var report: ReportDetail?
    @Published var userRating: ReportRatingResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let reportsController = ReportsController(httpClient: HTTPClient())

    func loadReportDetail(id: Int) async {
        isLoading = true
        errorMessage = nil

        do {
            report = try await reportsController.getReportDetail(id: id)
            // TODO: Load user's rating if they have one
            // This would require a new endpoint to get user's rating for a specific report
            isLoading = false
        } catch {
            errorMessage = "Error al cargar el reporte: \(error.localizedDescription)"
            isLoading = false
        }
    }

    func submitRating(reportId: Int, score: Int, comment: String?) async -> Bool {
        do {
            if let existingRating = userRating {
                // Update existing rating
                let request = UpdateReportRatingRequest(score: score, comment: comment)
                let response = try await reportsController.updateReportRating(
                    reportId: reportId,
                    ratingId: existingRating.ratingId,
                    request: request
                )
                userRating = response
            } else {
                // Create new rating
                let request = CreateReportRatingRequest(score: score, comment: comment)
                let response = try await reportsController.createReportRating(reportId: reportId, request: request)
                userRating = response
            }

            // Reload report to get updated average
            await loadReportDetail(id: reportId)

            return true
        } catch {
            print("Error al enviar calificación: \(error.localizedDescription)")
            return false
        }
    }

    func deleteRating(reportId: Int) async -> Bool {
        guard let rating = userRating else { return false }

        do {
            let success = try await reportsController.deleteReportRating(reportId: reportId, ratingId: rating.ratingId)
            if success {
                userRating = nil
                // Reload report to get updated average
                await loadReportDetail(id: reportId)
            }
            return success
        } catch {
            print("Error al eliminar calificación: \(error.localizedDescription)")
            return false
        }
    }
}

#Preview {
    NavigationStack {
        ReportDetailView(reportId: 1)
    }
}
