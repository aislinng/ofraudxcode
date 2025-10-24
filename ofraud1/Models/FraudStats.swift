//
//  FraudStats.swift
//  ofraud1
//
//  Created by Aislinn Gil on 16/10/25.
//

import Foundation

struct FraudStats: Codable, Hashable {
    let averageDetectionDays: Int
    let totalReportsApproved: Int
    let reportsThisWeek: Int
    let reportsThisMonth: Int
    let totalActiveUsers: Int
    let categoriesCount: Int
}
