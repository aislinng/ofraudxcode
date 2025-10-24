//
//  InsightsView.swift
//  ofraud1
//
//  Created by Aislinn Gil on 16/10/25.
//

import SwiftUI
import Charts

struct InsightsView: View {
    @StateObject private var viewModel = InsightsViewModel()
    @State private var selectedTopic: EducationalTopic?
    @State private var showingEducationalContent = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.systemBackground.ignoresSafeArea()

                if viewModel.isLoading && viewModel.fraudStats == nil {
                    ProgressView("Cargando insights...")
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
                                await viewModel.loadInsights()
                            }
                        }
                        .buttonStyle(.styled)
                    }
                    .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            // Header
                            HStack {
                                Text("Insights")
                                    .font(.largeTitle.bold())

                                Spacer()

                                Image("Ofraud")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 40)
                            }
                            .padding(.horizontal)

                            // Gráfico de Top Hosts (como en clase)
                            if !viewModel.topHosts.isEmpty {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Empresas con más reportes")
                                        .font(.title3.bold())

                                    // Chart con BarMark (exactamente como en clase)
                                    Chart(viewModel.topHosts) { host in
                                        BarMark(
                                            x: .value("Empresa", host.host),
                                            y: .value("Reportes", host.reportCount)
                                        )
                                        .annotation(position: .top) {
                                            Text(String(format: "%.0f", Double(host.reportCount)))
                                                .font(.caption2)
                                        }
                                    }
                                    .frame(height: 250)
                                    .padding(.horizontal)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(16)
                                .shadow(color: Color.black.opacity(0.05), radius: 8)
                                .padding(.horizontal)
                            }

                            // Gráfico de Categorías (como en clase)
                            if !viewModel.categories.isEmpty {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Reportes por Categoría")
                                        .font(.title3.bold())

                                    // Chart con BarMark (exactamente como en clase)
                                    Chart(viewModel.categories) { category in
                                        BarMark(
                                            x: .value("Categoría", category.name),
                                            y: .value("Reportes", category.reportsCount)
                                        )
                                        .annotation(position: .top) {
                                            Text(String(format: "%.0f", Double(category.reportsCount)))
                                                .font(.caption2)
                                        }
                                    }
                                    .frame(height: 250)
                                    .padding(.horizontal)

                                    // Botón para ver todas las categorías
                                    NavigationLink {
                                        CategoriesView()
                                    } label: {
                                        Text("Ver todas las categorías")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(Color.gray.opacity(0.3))
                                            .cornerRadius(12)
                                    }
                                    .padding(.horizontal)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(16)
                                .shadow(color: Color.black.opacity(0.05), radius: 8)
                                .padding(.horizontal)
                            }

                            // Tiempo promedio de detección
                            if let stats = viewModel.fraudStats {
                                VStack(spacing: 16) {
                                    Text("Tiempo promedio de detección de fraude en México")
                                        .font(.headline)
                                        .multilineTextAlignment(.center)

                                    Text("\(stats.averageDetectionDays)")
                                        .font(.system(size: 72, weight: .bold))
                                        .foregroundColor(.brandPrimary)
                                    + Text(" días")
                                        .font(.title.bold())

                                    Text("Los usuarios suelen percatarse de estos fraudes después de aproximadamente \(stats.averageDetectionDays) días.")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)

                                    // Estadísticas adicionales
                                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                        StatCard(
                                            title: "Reportes Aprobados",
                                            value: "\(stats.totalReportsApproved)",
                                            icon: "checkmark.seal.fill",
                                            color: .green
                                        )
                                        StatCard(
                                            title: "Esta Semana",
                                            value: "\(stats.reportsThisWeek)",
                                            icon: "calendar",
                                            color: .brandPrimary
                                        )
                                        StatCard(
                                            title: "Este Mes",
                                            value: "\(stats.reportsThisMonth)",
                                            icon: "calendar.badge.clock",
                                            color: .brandSecondary
                                        )
                                        StatCard(
                                            title: "Usuarios Activos",
                                            value: "\(stats.totalActiveUsers)",
                                            icon: "person.3.fill",
                                            color: .purple
                                        )
                                    }
                                    .padding(.top, 8)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(16)
                                .shadow(color: Color.black.opacity(0.05), radius: 8)
                                .padding(.horizontal)
                            }

                            // Botones de acceso a contenido educativo
                            if !viewModel.educationalTopics.isEmpty {
                                VStack(spacing: 16) {
                                    ForEach(viewModel.educationalTopics) { topic in
                                        Button(action: {
                                            selectedTopic = topic
                                            showingEducationalContent = true
                                        }) {
                                            Text(topic.displayTitle)
                                                .font(.headline)
                                                .foregroundColor(.black)
                                                .frame(maxWidth: .infinity)
                                                .padding()
                                                .background(Color.yellow.opacity(0.3))
                                                .cornerRadius(12)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                    .refreshable {
                        await viewModel.loadInsights()
                    }
                }
            }
            .task {
                if viewModel.fraudStats == nil {
                    await viewModel.loadInsights()
                }
            }
            .sheet(isPresented: $showingEducationalContent) {
                if let topic = selectedTopic {
                    EducationalContentView(topic: topic.topic)
                }
            }
        }
    }
}

#Preview {
    InsightsView()
}
