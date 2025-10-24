//
//  UpdateUserProfile.swift
//  ofraud1
//
//  Created by Aislinn Gil on 23/10/25.
//

import Foundation

struct UpdateUserProfileDto: Codable {
    let firstName: String?
    let lastName: String?
    let username: String?
    let phoneNumber: String?
    let profilePicture: String?
}

struct UpdateUserPasswordDto: Codable {
    let currentPassword: String
    let newPassword: String
}
