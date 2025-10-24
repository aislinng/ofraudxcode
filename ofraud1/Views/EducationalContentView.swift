//
//  EducationalContentView.swift
//  ofraud1
//
//  Created by aislinn
//  on 16/10/25.
//

import SwiftUI

struct EducationalContentView: View {
    let topic: String

    @StateObject private var viewModel = EducationalContentViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.systemBackground.ignoresSafeArea()

                if viewModel.isLoading {
                    ProgressView("Cargando contenido...")
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
                                await viewModel.loadContent(topic: topic)
                            }
                        }
                        .buttonStyle(.styled)
                    }
                    .padding()
                } else if let content = viewModel.content {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            // Title
                            Text(content.title)
                                .font(.title.bold())
                                .foregroundColor(.primary)

                            // Description
                            Text(content.description)
                                .font(.body)
                                .foregroundColor(.primary)

                            // Tips
                            if let tips = content.tips, !tips.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Consejos")
                                        .font(.title2.bold())

                                    ForEach(tips) { tip in
                                        HStack(alignment: .top, spacing: 12) {
                                            Image(systemName: tip.icon)
                                                .font(.title3)
                                                .foregroundColor(.brandPrimary)
                                                .frame(width: 30)

                                            Text(tip.text)
                                                .font(.body)
                                                .foregroundColor(.primary)
                                        }
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .shadow(color: Color.black.opacity(0.05), radius: 4)
                                    }
                                }
                            }

                            // Steps
                            if let steps = content.steps, !steps.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Pasos a seguir")
                                        .font(.title2.bold())

                                    ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                                        HStack(alignment: .top, spacing: 12) {
                                            ZStack {
                                                Circle()
                                                    .fill(Color.brandPrimary)
                                                    .frame(width: 30, height: 30)

                                                Text("\(index + 1)")
                                                    .font(.headline)
                                                    .foregroundColor(.white)
                                            }

                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(step.title)
                                                    .font(.headline)
                                                    .foregroundColor(.primary)

                                                Text(step.description)
                                                    .font(.body)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(12)
                                        .shadow(color: Color.black.opacity(0.05), radius: 4)
                                    }
                                }
                            }

                            // Additional info
                            if let additionalInfo = content.additionalInfo {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Información adicional")
                                        .font(.title2.bold())

                                    Text(additionalInfo)
                                        .font(.body)
                                        .foregroundColor(.primary)
                                        .padding()
                                        .background(Color.yellow.opacity(0.1))
                                        .cornerRadius(12)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Contenido Educativo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
            .task {
                await viewModel.loadContent(topic: topic)
            }
        }
    }
}

@MainActor
class EducationalContentViewModel: ObservableObject {
    @Published var content: EducationalContent?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let insightsController = InsightsController(httpClient: HTTPClient())

    func loadContent(topic: String) async {
        isLoading = true
        errorMessage = nil

        do {
            content = try await insightsController.getEducationalContent(topic: topic)
            isLoading = false
        } catch {
            errorMessage = "Error al cargar el contenido: \(error.localizedDescription)"
            isLoading = false
        }
    }
}

#Preview {
    EducationalContentView(topic: "phishing")
}
