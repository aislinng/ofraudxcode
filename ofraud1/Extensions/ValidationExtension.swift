//
//  ValidationExtension.swift
//  ofraud1
//
//  Created by Aislinn Gil on 07/10/25.
//

import Foundation
extension String {
    var isEmptyOrWhitespace: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return range(of: emailRegex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    var isValidPassword: Bool {
        return count >= 6
    }
    var isValidPhoneNumber: Bool {
        let phoneRegex = "^[0-9]{10,15}$"
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.range(of: phoneRegex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    var isValidName: Bool {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.count >= 2 && !trimmed.isEmptyOrWhitespace
    }
}
