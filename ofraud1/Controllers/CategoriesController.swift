//
//  CategoriesController.swift
//  ofraud1
//
//  Created by Aislinn Gil  on 16/10/25.
//

import Foundation

struct CategoriesController {
    let httpClient: HTTPClient

    func getCategories() async throws -> [Category] {
        return try await httpClient.getCategories()
    }
}
