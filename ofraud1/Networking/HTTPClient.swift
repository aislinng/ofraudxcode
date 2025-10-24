//
//  HTTPClient.swift
//  ofraud1
//
//  Created by Aislinn Gil on 07/10/25.
//

import Foundation
import UIKit

extension Notification.Name {
    static let userSessionExpired = Notification.Name("userSessionExpired")
}

struct HTTPClient {

    // MARK: - Helper Methods

    private func handleUnauthorized() throws -> Never {
        print("⚠️ [HTTPClient] Token inválido (401) - limpiando tokens almacenados")
        TokenStorage.delete(identifier: "accessToken")
        TokenStorage.delete(identifier: "refreshToken")

        // Notificar que la sesión expiró
        NotificationCenter.default.post(name: .userSessionExpired, object: nil)

        let errorMessage = "Sesión expirada. Por favor, inicia sesión nuevamente."
        throw NSError(domain: "HTTPClient", code: 401, userInfo: [NSLocalizedDescriptionKey: errorMessage])
    }

    private func createRequest(url: URL, method: String, body: Data? = nil, requiresAuth: Bool = false) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        if requiresAuth, let token = TokenStorage.get(identifier: "accessToken") {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        request.httpBody = body
        return request
    }

    // MARK: - Auth Methods

    func loginUser(email: String, password: String) async throws -> UserLoginReponse {
        print("🔵 [HTTPClient] Iniciando login para email: \(email)")

        do {
            let userLoginRequest = UserLoginRequest(email: email, password: password)
            print("🔵 [HTTPClient] Request creado: \(userLoginRequest)")

            let jsonData = try JSONEncoder().encode(userLoginRequest)
            print("🔵 [HTTPClient] JSON encoded: \(String(data: jsonData, encoding: .utf8) ?? "No se pudo convertir")")

            guard let url = URL(string: URLEndpoints.login) else {
                print("❌ [HTTPClient] URL inválida: \(URLEndpoints.login)")
                throw NSError(domain: "HTTPClient", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL del login es inválida"])
            }
            print("🔵 [HTTPClient] URL: \(url.absoluteString)")

            let request = createRequest(url: url, method: "POST", body: jsonData)
            print("🔵 [HTTPClient] Request configurado. Headers: \(request.allHTTPHeaderFields ?? [:])")

            print("🔵 [HTTPClient] Enviando request al servidor...")
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse {
                print("🔵 [HTTPClient] Respuesta recibida. Status code: \(httpResponse.statusCode)")
                print("🔵 [HTTPClient] Response headers: \(httpResponse.allHeaderFields)")

                // Aceptar códigos de éxito: 200 (OK) y 201 (Created)
                if httpResponse.statusCode != 200 && httpResponse.statusCode != 201 {
                    let errorMessage = String(data: data, encoding: .utf8) ?? "Sin mensaje de error"
                    print("❌ [HTTPClient] Error del servidor: \(errorMessage)")
                    throw NSError(domain: "HTTPClient", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Error del servidor: \(errorMessage)"])
                }
            }

            print("🔵 [HTTPClient] Datos recibidos: \(String(data: data, encoding: .utf8) ?? "No se pudo convertir")")

            let userLoginResponse = try JSONDecoder().decode(UserLoginReponse.self, from: data)
            print("✅ [HTTPClient] Login response decodificado exitosamente")
            print("🔵 [HTTPClient] AccessToken (primeros 20 chars): \(String(userLoginResponse.accessToken.prefix(20)))...")
            print("🔵 [HTTPClient] RefreshToken (primeros 20 chars): \(String(userLoginResponse.refreshToken.prefix(20)))...")

            return userLoginResponse

        } catch let decodingError as DecodingError {
            print("❌ [HTTPClient] Error de decodificación: \(decodingError)")
            switch decodingError {
            case .keyNotFound(let key, let context):
                print("❌ Key '\(key.stringValue)' no encontrado - \(context.debugDescription)")
            case .typeMismatch(let type, let context):
                print("❌ Type mismatch para tipo \(type) - \(context.debugDescription)")
            case .valueNotFound(let type, let context):
                print("❌ Value not found para tipo \(type) - \(context.debugDescription)")
            case .dataCorrupted(let context):
                print("❌ Data corrupted - \(context.debugDescription)")
            @unknown default:
                print("❌ Error de decodificación desconocido")
            }
            throw decodingError

        } catch let urlError as URLError {
            print("❌ [HTTPClient] Error de red: \(urlError.localizedDescription)")
            print("❌ [HTTPClient] URLError code: \(urlError.code.rawValue)")
            throw NSError(domain: "HTTPClient", code: -2, userInfo: [NSLocalizedDescriptionKey: "Error de conexión: \(urlError.localizedDescription)"])

        } catch {
            print("❌ [HTTPClient] Error inesperado: \(error.localizedDescription)")
            throw error
        }
    }

    func registerUser(email: String, username: String, firstName: String, lastName: String, phoneNumber: String?, password: String) async throws -> Bool {
        print("🟡 [HTTPClient] Iniciando registro para email: \(email)")

        do {
            let dataRequest = UserRequest(
                email: email,
                username: username,
                firstName: firstName,
                lastName: lastName,
                phoneNumber: phoneNumber,
                password: password,
                role: nil  // Default to nil, backend will set it to "user"
            )

            let jsonData = try JSONEncoder().encode(dataRequest)
            print("🟡 [HTTPClient] JSON encoded: \(String(data: jsonData, encoding: .utf8) ?? "No se pudo convertir")")

            guard let url = URL(string: URLEndpoints.register) else {
                print("❌ [HTTPClient] URL inválida: \(URLEndpoints.register)")
                throw NSError(domain: "HTTPClient", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL del registro es inválida"])
            }
            print("🟡 [HTTPClient] URL: \(url.absoluteString)")

            let request = createRequest(url: url, method: "POST", body: jsonData)
            print("🟡 [HTTPClient] Request configurado. Headers: \(request.allHTTPHeaderFields ?? [:])")

            print("🟡 [HTTPClient] Enviando request al servidor...")
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse {
                print("🟡 [HTTPClient] Respuesta recibida. Status code: \(httpResponse.statusCode)")
                print("🟡 [HTTPClient] Response headers: \(httpResponse.allHeaderFields)")

                if httpResponse.statusCode == 201 {
                    print("✅ [HTTPClient] Usuario registrado exitosamente")
                    return true
                } else {
                    let errorMessage = String(data: data, encoding: .utf8) ?? "Sin mensaje de error"
                    print("❌ [HTTPClient] Error del servidor (código \(httpResponse.statusCode)): \(errorMessage)")
                    throw NSError(domain: "HTTPClient", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                }
            }

            print("❌ [HTTPClient] No se recibió respuesta HTTP válida")
            return false

        } catch let decodingError as DecodingError {
            print("❌ [HTTPClient] Error de codificación: \(decodingError)")
            throw decodingError

        } catch let urlError as URLError {
            print("❌ [HTTPClient] Error de red: \(urlError.localizedDescription)")
            print("❌ [HTTPClient] URLError code: \(urlError.code.rawValue)")
            throw NSError(domain: "HTTPClient", code: -2, userInfo: [NSLocalizedDescriptionKey: "Error de conexión: \(urlError.localizedDescription)"])

        } catch {
            print("❌ [HTTPClient] Error inesperado en registro: \(error.localizedDescription)")
            throw error
        }
    }

    // MARK: - Reports Methods

    func getReports() async throws -> GetReportsResponse {
        let url = URL(string: URLEndpoints.reports)!
        let request = createRequest(url: url, method: "GET")
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(GetReportsResponse.self, from: data)
        return response
    }

    func getReportDetail(id: Int) async throws -> ReportDetail {
        let url = URL(string: URLEndpoints.reportDetail(id: id))!
        let request = createRequest(url: url, method: "GET")
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(ReportDetail.self, from: data)
        return response
    }

    func getMyReports() async throws -> GetMyReportsResponse {
        print("📋 [HTTPClient] Iniciando getMyReports")

        let url = URL(string: URLEndpoints.myReports)!
        print("📋 [HTTPClient] URL: \(url.absoluteString)")

        let request = createRequest(url: url, method: "GET", requiresAuth: true)
        print("📋 [HTTPClient] Headers: \(request.allHTTPHeaderFields ?? [:])")

        // Verificar token
        if let token = TokenStorage.get(identifier: "accessToken") {
            print("📋 [HTTPClient] Token encontrado: \(String(token.prefix(20)))...")
        } else {
            print("⚠️ [HTTPClient] ADVERTENCIA: No se encontró token")
        }

        print("📋 [HTTPClient] Enviando request...")
        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse {
            print("📋 [HTTPClient] Respuesta recibida. Status code: \(httpResponse.statusCode)")

            if httpResponse.statusCode == 401 {
                print("❌ [HTTPClient] Error 401: Token inválido o expirado en getMyReports")
                try handleUnauthorized()
            }

            if httpResponse.statusCode != 200 {
                let errorMessage = String(data: data, encoding: .utf8) ?? "Error desconocido"
                print("❌ [HTTPClient] Error del servidor: \(errorMessage)")
                throw NSError(domain: "HTTPClient", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
            }
        }

        print("📋 [HTTPClient] Response data: \(String(data: data, encoding: .utf8) ?? "No se pudo convertir")")

        do {
            let decodedResponse = try JSONDecoder().decode(GetMyReportsResponse.self, from: data)
            print("✅ [HTTPClient] Mis reportes cargados exitosamente: \(decodedResponse.items.count) reportes")
            return decodedResponse
        } catch {
            print("❌ [HTTPClient] Error al decodificar respuesta: \(error)")
            throw error
        }
    }

    func createReport(report: CreateReportRequest) async throws -> CreateReportResponse {
        print("🟣 [HTTPClient] Iniciando createReport")

        let jsonData = try JSONEncoder().encode(report)
        print("🟣 [HTTPClient] JSON encoded: \(String(data: jsonData, encoding: .utf8) ?? "No se pudo convertir")")

        let url = URL(string: URLEndpoints.reports)!
        print("🟣 [HTTPClient] URL: \(url.absoluteString)")

        let request = createRequest(url: url, method: "POST", body: jsonData, requiresAuth: true)
        print("🟣 [HTTPClient] Headers: \(request.allHTTPHeaderFields ?? [:])")

        // Verificar token
        if let token = TokenStorage.get(identifier: "accessToken") {
            print("🟣 [HTTPClient] Token encontrado: \(String(token.prefix(20)))...")
        } else {
            print("⚠️ [HTTPClient] ADVERTENCIA: No se encontró token")
        }

        print("🟣 [HTTPClient] Enviando request...")
        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse {
            print("🟣 [HTTPClient] Respuesta recibida. Status code: \(httpResponse.statusCode)")

            if httpResponse.statusCode == 401 {
                print("❌ [HTTPClient] Error 401: Token inválido o expirado en createReport")
                try handleUnauthorized()
            }

            if httpResponse.statusCode != 201 && httpResponse.statusCode != 200 {
                let errorMessage = String(data: data, encoding: .utf8) ?? "Error desconocido"
                print("❌ [HTTPClient] Error del servidor: \(errorMessage)")
                throw NSError(domain: "HTTPClient", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
            }
        }

        print("🟣 [HTTPClient] Response data: \(String(data: data, encoding: .utf8) ?? "No se pudo convertir")")

        do {
            let decodedResponse = try JSONDecoder().decode(CreateReportResponse.self, from: data)
            print("✅ [HTTPClient] Reporte creado exitosamente: ID \(decodedResponse.reportId)")
            return decodedResponse
        } catch {
            print("❌ [HTTPClient] Error al decodificar respuesta: \(error)")
            throw error
        }
    }

    // MARK: - Categories Methods

    func getCategories() async throws -> [Category] {
        let url = URL(string: URLEndpoints.categories)!
        let request = createRequest(url: url, method: "GET")
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode([Category].self, from: data)
        return response
    }

    // MARK: - Insights Methods

    func getFraudStats() async throws -> FraudStats {
        let url = URL(string: URLEndpoints.fraudStats)!
        let request = createRequest(url: url, method: "GET")
        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse {
            print("📡 [HTTPClient] GET \(url.absoluteString) - Status: \(httpResponse.statusCode)")
        }

        do {
            let stats = try JSONDecoder().decode(FraudStats.self, from: data)
            print("✅ [HTTPClient] Successfully decoded FraudStats")
            return stats
        } catch {
            print("❌ [HTTPClient] Failed to decode FraudStats")
            print("📄 [HTTPClient] Response data: \(String(data: data, encoding: .utf8) ?? "Unable to convert")")
            print("🔴 [HTTPClient] Decoding error: \(error)")
            throw error
        }
    }

    func getTopHosts(period: String = "weekly", limit: Int = 10) async throws -> [TopHost] {
        let url = URL(string: URLEndpoints.topHosts(period: period, limit: limit))!
        let request = createRequest(url: url, method: "GET")
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode([TopHost].self, from: data)
        return response
    }

    func getEducationalTopics() async throws -> [EducationalTopic] {
        let url = URL(string: URLEndpoints.educationalTopics)!
        let request = createRequest(url: url, method: "GET")
        let (data, response) = try await URLSession.shared.data(for: request)

        // Log response for debugging
        if let httpResponse = response as? HTTPURLResponse {
            print("📡 [HTTPClient] GET \(url.absoluteString) - Status: \(httpResponse.statusCode)")
        }

        do {
            let topics = try JSONDecoder().decode([EducationalTopic].self, from: data)
            print("✅ [HTTPClient] Successfully decoded \(topics.count) educational topics")
            return topics
        } catch {
            print("❌ [HTTPClient] Failed to decode educational topics")
            print("📄 [HTTPClient] Response data: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to string")")
            print("🔴 [HTTPClient] Decoding error: \(error)")
            throw error
        }
    }

    func getEducationalContent(topic: String) async throws -> EducationalContent {
        let url = URL(string: URLEndpoints.educationalContent(topic: topic))!
        let request = createRequest(url: url, method: "GET")
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(EducationalContent.self, from: data)
        return response
    }

    // MARK: - User Profile Methods

    func getCurrentUser() async throws -> User {
        let url = URL(string: "\(URLEndpoints.server)/users/me")!

        // Check if token exists
        let token = TokenStorage.get(identifier: "accessToken")
        print("🔐 [HTTPClient] Token exists: \(token != nil)")
        if let token = token {
            print("🔐 [HTTPClient] Token preview: \(String(token.prefix(20)))...")
        }

        let request = createRequest(url: url, method: "GET", requiresAuth: true)
        print("📡 [HTTPClient] GET \(url.absoluteString)")
        print("📡 [HTTPClient] Headers: \(request.allHTTPHeaderFields ?? [:])")

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse {
            print("📡 [HTTPClient] Response status: \(httpResponse.statusCode)")

            if httpResponse.statusCode == 401 {
                try handleUnauthorized()
            }

            if httpResponse.statusCode != 200 {
                let errorMessage = String(data: data, encoding: .utf8) ?? "Error al obtener usuario"
                print("❌ [HTTPClient] Error response: \(errorMessage)")
                throw NSError(domain: "HTTPClient", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
            }
        }

        do {
            let user = try JSONDecoder().decode(User.self, from: data)
            print("✅ [HTTPClient] User decoded successfully: \(user.email)")
            return user
        } catch {
            print("❌ [HTTPClient] Failed to decode user")
            print("📄 [HTTPClient] Response data: \(String(data: data, encoding: .utf8) ?? "Unable to convert")")
            throw error
        }
    }

    func updateUserProfile(dto: UpdateUserProfileDto) async throws -> User {
        let jsonData = try JSONEncoder().encode(dto)
        let url = URL(string: "\(URLEndpoints.server)/users/me")!
        let request = createRequest(url: url, method: "PATCH", body: jsonData, requiresAuth: true)
        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 401 {
                try handleUnauthorized()
            }

            if httpResponse.statusCode != 200 {
                let errorMessage = String(data: data, encoding: .utf8) ?? "Error al actualizar perfil"
                throw NSError(domain: "HTTPClient", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
            }
        }

        let user = try JSONDecoder().decode(User.self, from: data)
        return user
    }

    func updateUserPassword(dto: UpdateUserPasswordDto) async throws -> Bool {
        let jsonData = try JSONEncoder().encode(dto)
        let url = URL(string: "\(URLEndpoints.server)/users/me/password")!
        let request = createRequest(url: url, method: "PATCH", body: jsonData, requiresAuth: true)
        let (_, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 401 {
                try handleUnauthorized()
            }
            return httpResponse.statusCode == 200
        }
        return false
    }

    // MARK: - Report Rating Methods

    func createReportRating(reportId: Int, request: CreateReportRatingRequest) async throws -> ReportRatingResponse {
        let jsonData = try JSONEncoder().encode(request)
        let url = URL(string: "\(URLEndpoints.server)/reports/\(reportId)/ratings")!
        let httpRequest = createRequest(url: url, method: "POST", body: jsonData, requiresAuth: true)
        let (data, response) = try await URLSession.shared.data(for: httpRequest)

        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
            try handleUnauthorized()
        }

        let decodedResponse = try JSONDecoder().decode(ReportRatingResponse.self, from: data)
        return decodedResponse
    }

    func updateReportRating(reportId: Int, ratingId: Int, request: UpdateReportRatingRequest) async throws -> ReportRatingResponse {
        let jsonData = try JSONEncoder().encode(request)
        let url = URL(string: "\(URLEndpoints.server)/reports/\(reportId)/ratings/\(ratingId)")!
        let httpRequest = createRequest(url: url, method: "PATCH", body: jsonData, requiresAuth: true)
        let (data, response) = try await URLSession.shared.data(for: httpRequest)

        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
            try handleUnauthorized()
        }

        let decodedResponse = try JSONDecoder().decode(ReportRatingResponse.self, from: data)
        return decodedResponse
    }

    func deleteReportRating(reportId: Int, ratingId: Int) async throws -> Bool {
        let url = URL(string: "\(URLEndpoints.server)/reports/\(reportId)/ratings/\(ratingId)")!
        let httpRequest = createRequest(url: url, method: "DELETE", requiresAuth: true)
        let (_, response) = try await URLSession.shared.data(for: httpRequest)

        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 401 {
                try handleUnauthorized()
            }
            return httpResponse.statusCode == 200
        }
        return false
    }

    // MARK: - File Upload Methods

    func uploadImage(image: UIImage) async throws -> FileUploadResponse {
        print("🔷 [HTTPClient] Iniciando uploadImage")

        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("❌ [HTTPClient] Error: No se pudo convertir la imagen a JPEG")
            throw NSError(domain: "HTTPClient", code: -1, userInfo: [NSLocalizedDescriptionKey: "No se pudo convertir la imagen"])
        }
        print("🔷 [HTTPClient] Imagen convertida a JPEG: \(imageData.count) bytes")

        let url = URL(string: URLEndpoints.uploadFile)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        print("🔷 [HTTPClient] URL: \(url.absoluteString)")

        // Add auth token
        if let token = TokenStorage.get(identifier: "accessToken") {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print("🔷 [HTTPClient] Token agregado: \(String(token.prefix(20)))...")
        } else {
            print("⚠️ [HTTPClient] ADVERTENCIA: No se encontró token de acceso")
        }

        // Create multipart form data
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        // Add image data
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body
        print("🔷 [HTTPClient] Request body size: \(body.count) bytes")
        print("🔷 [HTTPClient] Enviando request...")

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse {
            print("🔷 [HTTPClient] Respuesta recibida. Status code: \(httpResponse.statusCode)")

            if httpResponse.statusCode == 401 {
                print("❌ [HTTPClient] Error 401: Token inválido o expirado")
                try handleUnauthorized()
            }

            if httpResponse.statusCode != 201 && httpResponse.statusCode != 200 {
                let errorMessage = String(data: data, encoding: .utf8) ?? "Error desconocido"
                print("❌ [HTTPClient] Error del servidor: \(errorMessage)")
                throw NSError(domain: "HTTPClient", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
            }
        }

        print("🔷 [HTTPClient] Response data: \(String(data: data, encoding: .utf8) ?? "No se pudo convertir")")

        do {
            let decodedResponse = try JSONDecoder().decode(FileUploadResponse.self, from: data)
            print("✅ [HTTPClient] Archivo subido exitosamente: \(decodedResponse.path)")
            return decodedResponse
        } catch {
            print("❌ [HTTPClient] Error al decodificar respuesta: \(error)")
            throw error
        }
    }

    func updateProfilePicture(image: UIImage) async throws -> User {
        // 1. Subir la imagen primero
        let uploadResponse = try await uploadImage(image: image)

        // 2. Actualizar el perfil con la ruta de la imagen
        let dto = UpdateUserProfileDto(
            firstName: nil,
            lastName: nil,
            username: nil,
            phoneNumber: nil,
            profilePicture: uploadResponse.path
        )

        return try await updateUserProfile(dto: dto)
    }
}

