//
//  TokenStorage.swift
//  ofraud1
//
//  Created by Aislinn Gil on 07/10/25.
//

import Foundation
struct TokenStorage {
    static func set(identifier: String, value: String) {
        UserDefaults.standard.set(value, forKey: identifier)
    }
 
    static func get(identifier: String) -> String? {
        UserDefaults.standard.string(forKey: identifier)
    }
 
    static func delete(identifier: String) {
        UserDefaults.standard.removeObject(forKey: identifier)
    }
}
