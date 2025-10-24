//
//  RatingSheet.swift
//  ofraud1
//
//  Created by Aislinn Gil on 23/10/25.
//

import SwiftUI

struct RatingSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var isPresented: Bool

    let reportId: Int
    let existingRating: ReportRatingResponse?
    let onSubmit: (Int, String?) async -> Bool
    let onDelete: (() async -> Bool)?

    @State private var selectedRating: Int
    @State private var comment: String
    @State private var isSubmitting = false
    @State private var showDeleteAlert = false
    @State private var errorMessage: String?

    init(
        isPresented: Binding<Bool>,
        reportId: Int,
        existingRating: ReportRatingResponse? = nil,
        onSubmit: @escaping (Int, String?) async -> Bool,
        onDelete: (() async -> Bool)? = nil
    ) {
        self._isPresented = isPresented
        self.reportId = reportId
        self.existingRating = existingRating
        self.onSubmit = onSubmit
        self.onDelete = onDelete

        // Inicializar con calificación existente o default
        _selectedRating = State(initialValue: existingRating?.score ?? 0)
        _comment = State(initialValue: existingRating?.comment ?? "")
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Image(systemName: "star.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.brandPrimary)

                        Text(existingRating != nil ? "Editar Calificación" : "Calificar Reporte")
                            .font(.title2.bold())

                        Text("Tu opinión ayuda a la comunidad")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top)

                    VStack(spacing: 12) {
                        Text("Selecciona tu calificación")
                            .font(.headline)

                        RatingView(rating: $selectedRating, interactive: true)

                        if selectedRating > 0 {
                            Text(ratingText)
                                .font(.subheadline)
                                .foregroundColor(.brandPrimary)
                                .animation(.easeInOut, value: selectedRating)
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Comentario (opcional)")
                            .font(.headline)

                        TextEditor(text: $comment)
                            .frame(height: 120)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }

                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }

                    // Action buttons
                    VStack(spacing: 12) {
                        // Submit button
                        Button(action: submitRating) {
                            if isSubmitting {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text(existingRating != nil ? "Actualizar Calificación" : "Enviar Calificación")
                                    .font(.headline)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(selectedRating > 0 ? Color.brandPrimary : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .disabled(selectedRating == 0 || isSubmitting)

                        // Delete button (si existe una calificación previa)
                        if existingRating != nil, onDelete != nil {
                            Button(action: { showDeleteAlert = true }) {
                                Text("Eliminar Calificación")
                                    .font(.headline)
                                    .foregroundColor(.red)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(12)
                            .disabled(isSubmitting)
                        }
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                    .disabled(isSubmitting)
                }
            }
            .alert("Eliminar Calificación", isPresented: $showDeleteAlert) {
                Button("Cancelar", role: .cancel) { }
                Button("Eliminar", role: .destructive) {
                    Task {
                        await deleteRating()
                    }
                }
            } message: {
                Text("¿Estás seguro de que deseas eliminar tu calificación?")
            }
        }
    }

    private var ratingText: String {
        switch selectedRating {
        case 1: return "Muy malo"
        case 2: return "Malo"
        case 3: return "Regular"
        case 4: return "Bueno"
        case 5: return "Excelente"
        default: return ""
        }
    }

    private func submitRating() {
        Task {
            errorMessage = nil
            isSubmitting = true

            let trimmedComment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
            let finalComment = trimmedComment.isEmpty ? nil : trimmedComment

            let success = await onSubmit(selectedRating, finalComment)

            isSubmitting = false

            if success {
                dismiss()
            } else {
                errorMessage = "Error al enviar la calificación. Inténtalo nuevamente."
            }
        }
    }

    private func deleteRating() async {
        guard let deleteAction = onDelete else { return }

        errorMessage = nil
        isSubmitting = true

        let success = await deleteAction()

        isSubmitting = false

        if success {
            dismiss()
        } else {
            errorMessage = "Error al eliminar la calificación. Inténtalo nuevamente."
        }
    }
}

#Preview {
    RatingSheet(
        isPresented: .constant(true),
        reportId: 1,
        existingRating: nil,
        onSubmit: { rating, comment in
            print("Rating: \(rating), Comment: \(comment ?? "nil")")
            return true
        },
        onDelete: nil
    )
}
