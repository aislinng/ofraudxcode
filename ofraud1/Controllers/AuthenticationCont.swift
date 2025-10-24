//
//  AuthenticationCont.swift
//  ofraud1
//
//  Created by Aislinn Gil on 07/10/25.
//

import Foundation

struct AuthenticationController{
    let httpClient: HTTPClient
    
    func registerUser(email: String, username: String, firstName: String, lastName: String, phoneNumber: String?, password: String) async throws -> Bool {
        let registrationResponse = try await httpClient.registerUser(
            email: email,
            username: username,
            firstName: firstName,
            lastName: lastName,
            phoneNumber: phoneNumber,
            password: password
        )

        return registrationResponse
    }
    func loginUser(email:String, password:String) async throws ->
    Bool{
        print("🟢 [AuthController] Iniciando loginUser con email: \(email)")

        do {
            let loginResponse = try await httpClient.loginUser(email:email, password: password)
            print("🟢 [AuthController] Response recibido del HTTPClient")

            //aquí se guardan los tokens
            let accessToken = loginResponse.accessToken
            let refreshToken = loginResponse.refreshToken

            print("🟢 [AuthController] AccessToken recibido (primeros 20 chars): \(String(accessToken.prefix(20)))...")
            print("🟢 [AuthController] RefreshToken recibido (primeros 20 chars): \(String(refreshToken.prefix(20)))...")
            print("🟢 [AuthController] Guardando tokens en TokenStorage...")

            TokenStorage.set(identifier: "accessToken", value: accessToken)
            TokenStorage.set(identifier: "refreshToken", value: refreshToken)

            // Verificar que se guardó correctamente
            if let savedToken = TokenStorage.get(identifier: "accessToken") {
                print("✅ [AuthController] Token guardado exitosamente: \(savedToken.prefix(20))...")
            } else {
                print("❌ [AuthController] Error: Token NO se guardó correctamente")
                return false
            }

            print("✅ [AuthController] Login completado exitosamente")
            return true

        } catch {
            print("❌ [AuthController] Error en loginUser: \(error.localizedDescription)")
            throw error
        }
    }
    
}
