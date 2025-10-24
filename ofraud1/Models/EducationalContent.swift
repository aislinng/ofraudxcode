//
//  EducationalContent.swift
//  ofraud1
//
//  Created by Aislinn Gil on 16/10/25.
//

import Foundation

struct EducationalTip: Codable, Identifiable, Hashable {
    let icon: String
    let text: String

    var id: String { text }
}

struct EducationalStep: Codable, Identifiable, Hashable {
    let title: String
    let description: String

    var id: String { title }
}

struct EducationalContent: Codable, Hashable {
    let topic: String
    let title: String
    let description: String
    let tips: [EducationalTip]?
    let steps: [EducationalStep]?
    let additionalInfo: String?
}

struct EducationalTopic: Codable, Identifiable, Hashable {
    let topic: String
    let title: String?  // Optional to handle backend entries without title

    var id: String { topic }

    // Computed property for display name
    var displayTitle: String {
        title ?? topic.capitalized
    }
}
