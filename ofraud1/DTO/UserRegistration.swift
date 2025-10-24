//
//  UserRegistration.swift
//  ofraud1
//
//  Created by Aislinn Gil on 07/10/25.
// DTO of User Registration

import Foundation

struct UserRequest: Codable {
    let email: String
    let username: String
    let firstName: String
    let lastName: String
    let phoneNumber: String?
    let password: String
    let role: String?
}

//To be defined by the endpoint
struct UserResponse: Decodable {
    let id: Int, email: String, name: String
}
