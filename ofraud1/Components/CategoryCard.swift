//
//  CategoryCard.swift
//  ofraud1
//
//  Created by Aislinn Gil on 16/10/25.
//

import SwiftUI

struct CategoryCard: View {
    let category: Category

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: iconForCategory(category.slug))
                .font(.system(size: 40))
                .foregroundStyle(
                    .linearGradient(
                        colors: [.brandSecondary, .brandPrimary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Text(category.name)
                .font(.headline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)

            Text("\(category.reportsCount) reportes")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4)
    }

    private func iconForCategory(_ slug: String) -> String {
        switch slug {
        case "phishing":
            return "envelope.badge.shield.half.filled"
        case "identity-theft":
            return "person.badge.key"
        case "online-shopping":
            return "cart.badge.questionmark"
        case "investment-scam":
            return "chart.line.downtrend.xyaxis"
        case "romance-scam":
            return "heart.slash"
        case "tech-support":
            return "phone.badge.waveform"
        default:
            return "exclamationmark.triangle"
        }
    }
}
