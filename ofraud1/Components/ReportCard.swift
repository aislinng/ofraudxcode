//
//  ReportCard.swift
//  ofraud1
//
//  Created by Aislinn Gil on 16/10/25.
//

import SwiftUI

struct ReportCard: View {
    let report: ReportFeedItem

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 12) {
                // Avatar
                Image(systemName: report.author.isAnonymous ? "person.fill.questionmark" : "person.crop.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.brandPrimary)

                VStack(alignment: .leading, spacing: 2) {
                    Text(report.author.isAnonymous ? "Usuario Anónimo" : report.author.displayName ?? "Usuario")
                        .font(.subheadline.bold())
                        .foregroundColor(.primary)

                    HStack(spacing: 4) {
                        if let publishedAt = report.publishedAt {
                            Text(formatRelativeDate(publishedAt))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        if let categoryName = report.categoryName {
                            Text("•")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(categoryName)
                                .font(.caption)
                                .foregroundColor(.brandPrimary)
                        }
                    }
                }

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            // Primera foto del reporte (si existe)
            if let firstMedia = report.media.first {
                AsyncImage(url: URL(string: firstMedia.fileUrl)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .background(Color.gray.opacity(0.1))
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .clipped()
                    case .failure:
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.largeTitle)
                                    .foregroundColor(.gray)
                            )
                    @unknown default:
                        EmptyView()
                    }
                }
            }

            // Contenido principal
            VStack(alignment: .leading, spacing: 8) {
                // Título (si existe)
                if let title = report.title, !title.isEmpty {
                    Text(title)
                        .font(.body.bold())
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                // Descripción
                Text(report.description)
                    .font(.body)
                    .foregroundColor(.primary)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)

                // URL del incidente
                HStack(spacing: 6) {
                    Image(systemName: "link.circle.fill")
                        .font(.caption)
                        .foregroundColor(.brandPrimary)
                    Text(report.publisherHost)
                        .font(.caption)
                        .foregroundColor(.brandPrimary)
                    Spacer()
                }
                .padding(.top, 4)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)

            // Divider
            Divider()
                .padding(.horizontal, 16)

            // Footer - Estadísticas y acciones
            HStack(spacing: 24) {
                // Valoración
                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .font(.subheadline)
                        .foregroundColor(.yellow)
                    Text("\(report.ratingAverage, specifier: "%.1f")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("(\(report.ratingCount))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                // Indicador de más detalles
                HStack(spacing: 4) {
                    Text("Ver detalles")
                        .font(.caption)
                        .foregroundColor(.brandPrimary)
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.brandPrimary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color.white)
    }

    private func formatRelativeDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: dateString) else {
            return "Hace un momento"
        }

        let now = Date()
        let components = Calendar.current.dateComponents([.minute, .hour, .day, .weekOfYear], from: date, to: now)

        if let weeks = components.weekOfYear, weeks > 0 {
            return weeks == 1 ? "Hace 1 semana" : "Hace \(weeks) semanas"
        } else if let days = components.day, days > 0 {
            return days == 1 ? "Hace 1 día" : "Hace \(days) días"
        } else if let hours = components.hour, hours > 0 {
            return hours == 1 ? "Hace 1 hora" : "Hace \(hours) horas"
        } else if let minutes = components.minute, minutes > 0 {
            return minutes == 1 ? "Hace 1 minuto" : "Hace \(minutes) minutos"
        } else {
            return "Hace un momento"
        }
    }
}
