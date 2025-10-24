//
//  HomeView.swift
//  ofraud1
//
//  Created by Aislinn Gil on 16/10/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = ReportsViewModel()
    @State private var searchText = ""

    var filteredReports: [ReportFeedItem] {
        if searchText.isEmpty {
            return viewModel.reports
        }
        return viewModel.reports.filter { report in
            report.title?.localizedCaseInsensitiveContains(searchText) == true ||
            report.description.localizedCaseInsensitiveContains(searchText) ||
            report.publisherHost.localizedCaseInsensitiveContains(searchText) ||
            report.categoryName?.localizedCaseInsensitiveContains(searchText) == true
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.systemBackground.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text("Inicio")
                            .font(.largeTitle.bold())

                        Spacer()

                        Image("Ofraud")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                    }
                    .padding(.horizontal)
                    .padding(.top)

                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)

                        TextField("Buscar", text: $searchText)
                            .textFieldStyle(.plain)
                            .autocapitalization(.none)

                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.top, 10)

                    // Content - Lista de reportes
                    if viewModel.isLoading && viewModel.reports.isEmpty {
                        Spacer()
                        ProgressView("Cargando reportes...")
                        Spacer()
                    } else if let errorMessage = viewModel.errorMessage {
                        Spacer()
                        VStack(spacing: 16) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                            Text(errorMessage)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                            Button("Reintentar") {
                                Task {
                                    await viewModel.loadReports()
                                }
                            }
                            .buttonStyle(.styled)
                        }
                        .padding()
                        Spacer()
                    } else {
                        ScrollView {
                            VStack(spacing: 0) {
                                if filteredReports.isEmpty {
                                    VStack(spacing: 12) {
                                        Image(systemName: "doc.text.magnifyingglass")
                                            .font(.system(size: 50))
                                            .foregroundColor(.gray)
                                        Text(searchText.isEmpty ? "No hay reportes disponibles" : "No se encontraron resultados")
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.top, 50)
                                } else {
                                    ForEach(Array(filteredReports.enumerated()), id: \.element.id) { index, report in
                                        NavigationLink(destination: ReportDetailView(reportId: report.reportId)) {
                                            ReportCard(report: report)
                                        }
                                        .buttonStyle(PlainButtonStyle())

                                        // Divider entre tarjetas
                                        if index < filteredReports.count - 1 {
                                            Divider()
                                                .background(Color.gray.opacity(0.3))
                                                .frame(height: 8)
                                        }
                                    }
                                }
                            }
                        }
                        .refreshable {
                            await viewModel.refreshReports()
                        }
                    }
                }
            }
            .task {
                if viewModel.reports.isEmpty {
                    await viewModel.loadReports()
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
