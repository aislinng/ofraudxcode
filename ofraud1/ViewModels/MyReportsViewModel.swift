//
//  MyReportsViewModel.swift
//  ofraud1
//
//  Created by Aislinn Gil on 16/10/25.
//

import Foundation

@MainActor
class MyReportsViewModel: ObservableObject {
    @Published var reports: [MyReportItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let reportsController = ReportsController(httpClient: HTTPClient())

    func loadMyReports() async {
        print("📝 [MyReportsViewModel] Iniciando loadMyReports")
        isLoading = true
        errorMessage = nil

        do {
            print("📝 [MyReportsViewModel] Llamando a reportsController.getMyReports()")
            let response = try await reportsController.getMyReports()

            print("📝 [MyReportsViewModel] Respuesta recibida: \(response.items.count) reportes")
            reports = response.items

            isLoading = false
            print("✅ [MyReportsViewModel] Reportes cargados exitosamente")
        } catch {
            print("❌ [MyReportsViewModel] Error al cargar reportes: \(error)")
            print("❌ [MyReportsViewModel] Error localizedDescription: \(error.localizedDescription)")
            errorMessage = "Error al cargar tus reportes: \(error.localizedDescription)"
            isLoading = false
        }
    }

    func refreshReports() async {
        await loadMyReports()
    }
}
