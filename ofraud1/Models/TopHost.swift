//
//  TopHost.swift
//  ofraud1
//
//  Created by Aislinn Gil on 16/10/25.
//

import Foundation

struct TopHost: Codable, Identifiable, Hashable {
    let host: String
    let reportCount: Int
    let averageRating: Double?
    let totalRatings: Int

    var id: String { host }
}
