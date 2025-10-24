//
//  CategoriesViewModel.swift
//  ofraud1
//
//  Created by Aislinn Gil on 16/10/25.
//

import Foundation

@MainActor
class CategoriesViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let categoriesController = CategoriesController(httpClient: HTTPClient())

    func loadCategories() async {
        isLoading = true
        errorMessage = nil

        do {
            categories = try await categoriesController.getCategories()
            isLoading = false
        } catch {
            errorMessage = "Error al cargar categorías: \(error.localizedDescription)"
            isLoading = false
        }
    }
}
