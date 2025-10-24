//
//  AuthViewModel.swift
//  ofraud1
//
//  Created by Aislinn Gil on 16/10/25.
//

import Foundation
import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var showOnboarding = false
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    private let authController = AuthenticationController(httpClient: HTTPClient())

    init() {
        // Verificar si hay un token guardado al iniciar
        checkAuthStatus()

        // Escuchar notificaciones de sesión expirada
        NotificationCenter.default.addObserver(
            forName: .userSessionExpired,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.handleSessionExpired()
            }
        }
    }

    func checkAuthStatus() {
        // Verificar si existe un token de acceso
        if let token = TokenStorage.get(identifier: "accessToken"), !token.isEmpty {
            isAuthenticated = true
            isLoggedIn = true
        } else {
            isAuthenticated = false
            isLoggedIn = false
        }
    }

    func login(email: String, password: String) async throws -> Bool {
        print("🟡 [AuthViewModel] Iniciando login para email: \(email)")
        print("🟡 [AuthViewModel] Estado actual - isAuthenticated: \(isAuthenticated), isLoggedIn: \(isLoggedIn)")

        do {
            let success = try await authController.loginUser(email: email, password: password)
            print("🟡 [AuthViewModel] AuthController devolvió success: \(success)")

            if success {
                print("🟡 [AuthViewModel] Login exitoso, actualizando estados...")
                isAuthenticated = true
                isLoggedIn = true

                // Mostrar onboarding si es la primera vez
                if !hasCompletedOnboarding {
                    showOnboarding = true
                }

                print("✅ [AuthViewModel] Estados actualizados - isAuthenticated: \(isAuthenticated), isLoggedIn: \(isLoggedIn), showOnboarding: \(showOnboarding)")
            } else {
                print("❌ [AuthViewModel] Login falló, success = false")
            }

            return success

        } catch {
            print("❌ [AuthViewModel] Error capturado en login: \(error)")
            print("❌ [AuthViewModel] Error localizedDescription: \(error.localizedDescription)")
            throw error
        }
    }

    func completeOnboarding() {
        hasCompletedOnboarding = true
        showOnboarding = false
    }

    func logout() {
        // Limpiar tokens
        TokenStorage.delete(identifier: "accessToken")
        TokenStorage.delete(identifier: "refreshToken")

        // Actualizar estados
        isAuthenticated = false
        isLoggedIn = false

        print("✅ Sesión cerrada correctamente")
    }

    private func handleSessionExpired() {
        print("⚠️ [AuthViewModel] Sesión expirada detectada - cerrando sesión")
        isAuthenticated = false
        isLoggedIn = false
    }
}
