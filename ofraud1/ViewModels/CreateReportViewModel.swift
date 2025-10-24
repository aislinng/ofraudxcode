//
//  CreateReportViewModel.swift
//  ofraud1
//
//  Created by Aislinn Gil on 16/10/25.
//

import Foundation
import UIKit

@MainActor
class CreateReportViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var selectedCategory: Category?
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var incidentUrl: String = ""
    @Published var companyName: String = ""
    @Published var isAnonymous: Bool = false
    @Published var selectedImages: [UIImage] = []

    @Published var isLoading = false
    @Published var isUploading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var createdReportId: Int?

    private let categoriesController = CategoriesController(httpClient: HTTPClient())
    private let reportsController = ReportsController(httpClient: HTTPClient())
    private let fileController = FileController(httpClient: HTTPClient())

    func loadCategories() async {
        do {
            categories = try await categoriesController.getCategories()
            if !categories.isEmpty {
                selectedCategory = categories[0]
            }
        } catch {
            errorMessage = "Error al cargar categorías: \(error.localizedDescription)"
        }
    }

    func submitReport() async -> Bool {
        guard let category = selectedCategory else {
            errorMessage = "Por favor selecciona una categoría"
            return false
        }

        guard !description.isEmpty else {
            errorMessage = "Por favor describe el incidente"
            return false
        }

        guard !incidentUrl.isEmpty else {
            errorMessage = "Por favor ingresa la URL del incidente"
            return false
        }

        guard !selectedImages.isEmpty else {
            errorMessage = "Por favor agrega al menos una imagen"
            return false
        }

        isLoading = true
        isUploading = true
        errorMessage = nil

        do {
            var uploadedMedia: [CreateReportMediaDTO] = []

            for (index, image) in selectedImages.enumerated() {
                let uploadResponse = try await fileController.uploadImage(image: image)
                let media = CreateReportMediaDTO(
                    fileUrl: uploadResponse.path,
                    mediaType: "image",
                    position: index + 1
                )
                uploadedMedia.append(media)
            }

            isUploading = false

            let reportRequest = CreateReportRequest(
                categoryId: category.id,
                title: title.isEmpty ? nil : title,
                description: description,
                incidentUrl: incidentUrl,
                isAnonymous: isAnonymous,
                publisherHost: companyName.isEmpty ? nil : companyName,
                media: uploadedMedia
            )

            let response = try await reportsController.createReport(report: reportRequest)
            createdReportId = response.reportId

            isLoading = false
            successMessage = "Reporte enviado exitosamente. Será revisado por nuestro equipo."

            return true
        } catch {
            isLoading = false
            isUploading = false
            errorMessage = "Error al enviar reporte: \(error.localizedDescription)"
            return false
        }
    }

    func resetForm() {
        title = ""
        description = ""
        incidentUrl = ""
        companyName = ""
        isAnonymous = false
        selectedImages = []
        createdReportId = nil
        if !categories.isEmpty {
            selectedCategory = categories[0]
        }
    }
}
