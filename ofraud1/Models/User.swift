//
//  User.swift
//  ofraud1
//
//  Created by Aislinn Gil on 16/10/25.
//

import Foundation

enum UserRole: String, Codable {
    case user = "user"
    case admin = "admin"
}

struct User: Codable, Identifiable, Hashable {
    let id: Int
    let email: String
    let username: String
    let firstName: String
    let lastName: String
    let phoneNumber: String?
    let role: UserRole
    let isBlocked: Bool
    let blockedReason: String?
    let blockedBy: Int?
    let blockedAt: String?
    let profilePicture: String?

    var fullName: String {
        "\(firstName) \(lastName)"
    }
}
