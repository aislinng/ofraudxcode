//
//  CategoriesView.swift
//  ofraud1
//
//  Created by Aislinn Gil on 16/10/25.
//

import SwiftUI

struct CategoriesView: View {
    @StateObject private var viewModel = CategoriesViewModel()
    @State private var searchText = ""
    @Environment(\.dismiss) var dismiss

    var filteredCategories: [Category] {
        if searchText.isEmpty {
            return viewModel.categories
        } else {
            return viewModel.categories.filter { category in
                category.name.localizedCaseInsensitiveContains(searchText) ||
                category.description?.localizedCaseInsensitiveContains(searchText) ?? false
            }
        }
    }

    var mostSearched: [Category] {
        filteredCategories.sorted { $0.searchCount > $1.searchCount }.prefix(6).map { $0 }
    }

    var mostReported: [Category] {
        filteredCategories.sorted { $0.reportsCount > $1.reportsCount }.prefix(6).map { $0 }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.systemBackground.ignoresSafeArea()

                if viewModel.isLoading && viewModel.categories.isEmpty {
                    ProgressView("Cargando categorías...")
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
                                await viewModel.loadCategories()
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
                                Button {
                                    dismiss()
                                } label: {
                                    Image(systemName: "chevron.left")
                                        .font(.title3)
                                        .foregroundColor(.primary)
                                }

                                Text("Categorías")
                                    .font(.largeTitle.bold())

                                Spacer()

                                Image("Ofraud")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 40)
                            }
                            .padding(.horizontal)

                            // Search Bar
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)

                                TextField("Buscar", text: $searchText)
                                    .autocapitalization(.none)

                                if !searchText.isEmpty {
                                    Button {
                                        searchText = ""
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .padding(.horizontal)

                            // Más Buscadas
                            if !mostSearched.isEmpty {
                                VStack(alignment: .leading, spacing: 16) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Más Buscadas")
                                            .font(.title3.bold())
                                            .foregroundColor(.brandPrimary)
                                        Text("Semanales")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.horizontal)

                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 12) {
                                            ForEach(mostSearched) { category in
                                                VStack(spacing: 8) {
                                                    Circle()
                                                        .fill(Color.blue.opacity(0.1))
                                                        .frame(width: 80, height: 80)
                                                        .overlay(
                                                            Image(systemName: iconForCategory(category.slug))
                                                                .font(.system(size: 32))
                                                                .foregroundColor(.blue)
                                                        )

                                                    Text(category.name)
                                                        .font(.caption.bold())
                                                        .foregroundColor(.primary)
                                                        .lineLimit(2)
                                                        .multilineTextAlignment(.center)
                                                        .frame(width: 100)

                                                    Text("\(category.searchCount)")
                                                        .font(.caption2.bold())
                                                        .foregroundColor(.blue)
                                                    Text("Búsquedas")
                                                        .font(.caption2)
                                                        .foregroundColor(.secondary)
                                                }
                                                .frame(width: 120)
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }

                            // Más Reportadas
                            if !mostReported.isEmpty {
                                VStack(alignment: .leading, spacing: 16) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Más Reportadas")
                                            .font(.title3.bold())
                                            .foregroundColor(.brandPrimary)
                                        Text("Semanales")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.horizontal)

                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 12) {
                                            ForEach(mostReported) { category in
                                                VStack(spacing: 8) {
                                                    Circle()
                                                        .fill(Color.orange.opacity(0.1))
                                                        .frame(width: 80, height: 80)
                                                        .overlay(
                                                            Image(systemName: iconForCategory(category.slug))
                                                                .font(.system(size: 32))
                                                                .foregroundColor(.orange)
                                                        )

                                                    Text(category.name)
                                                        .font(.caption.bold())
                                                        .foregroundColor(.primary)
                                                        .lineLimit(2)
                                                        .multilineTextAlignment(.center)
                                                        .frame(width: 100)

                                                    Text("\(category.reportsCount)")
                                                        .font(.caption2.bold())
                                                        .foregroundColor(.orange)
                                                    Text("Reportes")
                                                        .font(.caption2)
                                                        .foregroundColor(.secondary)
                                                }
                                                .frame(width: 120)
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }

                            // Todas las categorías (si hay búsqueda)
                            if !searchText.isEmpty && !filteredCategories.isEmpty {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Resultados de búsqueda")
                                        .font(.title3.bold())
                                        .foregroundColor(.brandPrimary)
                                        .padding(.horizontal)

                                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                        ForEach(filteredCategories) { category in
                                            CategoryCard(category: category)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationBarHidden(true)
            .task {
                if viewModel.categories.isEmpty {
                    await viewModel.loadCategories()
                }
            }
        }
    }

    private func iconForCategory(_ slug: String) -> String {
        switch slug {
        case "phishing":
            return "envelope.badge.shield.half.filled"
        case "identity-theft":
            return "person.badge.key"
        case "online-shopping":
            return "cart.badge.questionmark"
        case "investment-scam":
            return "chart.line.downtrend.xyaxis"
        case "romance-scam":
            return "heart.slash"
        case "tech-support":
            return "phone.badge.waveform"
        case "electrodomesticos":
            return "washer"
        case "hoteles":
            return "building.2"
        case "sitios-web":
            return "globe"
        case "cursos-en-linea":
            return "book.fill"
        case "viajes":
            return "airplane"
        case "muebles":
            return "chair.fill"
        default:
            return "star.circle"
        }
    }
}

#Preview {
    CategoriesView()
}
