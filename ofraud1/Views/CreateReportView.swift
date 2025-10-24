//
//  CreateReportView.swift
//  ofraud1
//
//  Created by Aislinn Gil on 16/10/25.
//

import SwiftUI

struct CreateReportView: View {
    @StateObject private var viewModel = CreateReportViewModel()
    @State private var showingConfirmation = false
    @State private var showingSuccess = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.systemBackground.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Registro de Reporte")
                            .font(.largeTitle.bold())

                        Text("Todos los campos son obligatorios*")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Categoría")
                                .font(.headline)

                            Menu {
                                ForEach(viewModel.categories) { category in
                                    Button(category.name) {
                                        viewModel.selectedCategory = category
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(viewModel.selectedCategory?.name ?? "Selecciona una categoría")
                                        .foregroundColor(viewModel.selectedCategory == nil ? .gray : .primary)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                            }
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Título (opcional)")
                                .font(.headline)

                            TextField("Breve título descriptivo", text: $viewModel.title)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("URL del incidente")
                                .font(.headline)

                            TextField("https://ejemplo.com", text: $viewModel.incidentUrl)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .keyboardType(.URL)
                                .autocapitalization(.none)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Nombre de la empresa o servicio (opcional)")
                                .font(.headline)

                            TextField("Empresa X", text: $viewModel.companyName)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Descripción del incidente")
                                .font(.headline)

                            TextEditor(text: $viewModel.description)
                                .frame(height: 120)
                                .padding(8)
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Imágenes de evidencia")
                                .font(.headline)

                            ImagePicker(selectedImages: $viewModel.selectedImages)
                        }

                        Toggle(isOn: $viewModel.isAnonymous) {
                            Text("Publicar Anónimamente")
                                .font(.headline)
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .brandSecondary))

                        Text("Al enviar un reporte aceptas los **Términos de Privacidad y Comunidad**")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 8)

                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.top, 8)
                        }

                        // Upload progress
                        if viewModel.isUploading {
                            HStack {
                                ProgressView()
                                Text("Subiendo imágenes...")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.top, 8)
                        }

                        // Botón enviar
                        Button(action: {
                            showingConfirmation = true
                        }) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Enviar")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.isLoading ? Color.gray : Color.brandSecondary)
                        .cornerRadius(12)
                        .disabled(viewModel.isLoading)
                        .padding(.top, 10)
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical)
                }
            }
            .confirmationDialog("Enviar Reporte", isPresented: $showingConfirmation, titleVisibility: .visible) {
                Button("Enviar", role: .none) {
                    Task {
                        let success = await viewModel.submitReport()
                        if success {
                            showingSuccess = true
                        }
                    }
                }
                Button("Cancelar", role: .cancel) { }
                Button("Editar Reporte", role: .none) {
                    showingConfirmation = false
                }
            } message: {
                Text("Una vez enviado no se podrá editar, podrás agregar más reportes en la sección correspondiente.")
            }
            .fullScreenCover(isPresented: $showingSuccess) {
                if let reportId = viewModel.createdReportId {
                    ReportSuccessView(reportId: reportId)
                        .onDisappear {
                            viewModel.resetForm()
                        }
                }
            }
            .task {
                if viewModel.categories.isEmpty {
                    await viewModel.loadCategories()
                }
            }
        }
    }
}

#Preview {
    CreateReportView()
}
