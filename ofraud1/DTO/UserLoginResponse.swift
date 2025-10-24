//
//  UserLoginResponse.swift
//  ofraud1
//
//  Created by Aislinn Gil on 07/10/25.
//DTO of UserLogin Response

import Foundation

struct UserLoginRequest: Codable {
    let email, password: String
}

struct UserLoginReponse: Decodable {
    let message: String?  // Opcional para compatibilidad
    let accessToken, refreshToken: String
}

