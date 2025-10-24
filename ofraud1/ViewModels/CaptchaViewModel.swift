//
//  CaptchaViewModel.swift
//  ofraud1
//
//  Created by Aislinn Gil on 22/10/25.
//

import Foundation
import RecaptchaEnterprise
import SwiftUI

enum RecaptchaError: Error {
    case clientNotReady
    case verificationFailed(Error)
    var localizedDescription: String {
        switch self {
        case .clientNotReady:
            return "El cliente de reCAPTCHA no está listo. Intente de nuevo."
        case .verificationFailed(let error):
            return "Falló la verificación de reCAPTCHA: \(error.localizedDescription)"
        }
    }
}


@MainActor
class RecaptchaViewModel: ObservableObject {
    
    private var recaptchaClient: RecaptchaClient?

    init() {
        Task {
            do {
                self.recaptchaClient = try await Recaptcha.fetchClient(withSiteKey: "KEY_ID")
                print("Cliente reCAPTCHA inicializado.")
            } catch let error as RecaptchaEnterprise.RecaptchaError {
                print(" Error al inicializar reCAPTCHA: \(String(describing: error.errorMessage)).")
            } catch {
                print("Error desconocido al inicializar reCAPTCHA: \(error.localizedDescription)")
            }
        }
    }

    func executeAction() async throws -> String {
        guard let client = recaptchaClient else {
            throw RecaptchaError.clientNotReady
        }

        do {
            let action = RecaptchaEnterprise.RecaptchaAction(customAction: "signup")
            let token = try await client.execute(withAction: action)
            print("Token de reCAPTCHA obtenido.")
            return token
        } catch {
            print(" Error al ejecutar reCAPTCHA: \(error.localizedDescription)")
            throw RecaptchaError.verificationFailed(error)
        }
    }
}
