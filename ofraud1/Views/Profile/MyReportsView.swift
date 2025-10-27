//
//  MyReportsView.swift
//  ofraud1
//
//  Created by Aislinn Gil on 16/10/25.
//

import SwiftUI

struct MyReportsView: View {
    @StateObject private var viewModel = MyReportsViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Color.systemBackground.ignoresSafeArea()

                if viewModel.isLoading && viewModel.reports.isEmpty {
                    ProgressView("Cargando tus reportes...")
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
                                await viewModel.loadMyReports()
                            }
                        }
                        .buttonStyle(.styled)
                    }
                    .padding()
                } else if viewModel.reports.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("No has creado reportes aún")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("Tus reportes aparecerán aquí una vez que los crees")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(viewModel.reports) { report in
                                NavigationLink(destination: ReportDetailView(reportId: report.reportId)) {
                                    MyReportCard(report: report)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                    .refreshable {
                        await viewModel.refreshReports()
                    }
                }
            }
            .navigationTitle("Mis Reportes")
            .task {
                if viewModel.reports.isEmpty {
                    await viewModel.loadMyReports()
                }
            }
        }
    }
}

struct MyReportCard: View {
    let report: MyReportItem

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Status badge
            HStack {
                statusBadge(for: report.status)
                Spacer()
            }

            // Category
            if let categoryName = report.categoryName {
                Text(categoryName.uppercased())
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.brandPrimary)
            }

            // Title
            if let title = report.title {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
            } else {
                Text("Reporte sin título")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }

            // Dates
            HStack {
                Image(systemName: "calendar")
                    .font(.caption)
                Text("Creado: \(formatDate(report.createdAt))")
                    .font(.caption)
            }
            .foregroundColor(.secondary)

            if let lastEditedAt = report.lastEditedAt {
                HStack {
                    Image(systemName: "pencil")
                        .font(.caption)
                    Text("Editado: \(formatDate(lastEditedAt))")
                        .font(.caption)
                }
                .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4)
    }

    @ViewBuilder
    private func statusBadge(for status: ReportStatus) -> some View {
        HStack(spacing: 4) {
            Image(systemName: statusIcon(for: status))
            Text(statusText(for: status))
        }
        .font(.caption)
        .fontWeight(.bold)
        .foregroundColor(.white)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(statusColor(for: status))
        .cornerRadius(4)
    }

    private func statusIcon(for status: ReportStatus) -> String {
        switch status {
        case .pending:
            return "clock"
        case .approved:
            return "checkmark.seal.fill"
        case .rejected:
            return "xmark.circle.fill"
        case .removed:
            return "trash"
        }
    }

    private func statusText(for status: ReportStatus) -> String {
        switch status {
        case .pending:
            return "PENDIENTE"
        case .approved:
            return "APROBADO"
        case .rejected:
            return "RECHAZADO"
        case .removed:
            return "ELIMINADO"
        }
    }

    private func statusColor(for status: ReportStatus) -> Color {
        switch status {
        case .pending:
            return .orange
        case .approved:
            return .green
        case .rejected:
            return .red
        case .removed:
            return .gray
        }
    }

    private func formatDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: dateString) else {
            return dateString
        }

        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        return displayFormatter.string(from: date)
    }
}

#Preview {
    MyReportsView()
}
