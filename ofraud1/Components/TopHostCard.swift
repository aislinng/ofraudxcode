//
//  TopHostCard.swift
//  ofraud1
//
//  Created by Aislinn Gil on 16/10/25.
//

import SwiftUI

struct TopHostCard: View {
    let host: TopHost
    let rank: Int

    var body: some View {
        HStack(spacing: 12) {
            // Rank badge
            ZStack {
                Circle()
                    .fill(rank <= 3 ? Color.brandPrimary : Color.gray.opacity(0.2))
                    .frame(width: 40, height: 40)

                Text("\(rank)")
                    .font(.headline)
                    .foregroundColor(rank <= 3 ? .white : .primary)
            }

            // Host info
            VStack(alignment: .leading, spacing: 4) {
                Text(host.host)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)

                HStack(spacing: 8) {
                    Label("\(host.reportCount)", systemImage: "exclamationmark.triangle.fill")
                        .font(.caption)
                        .foregroundColor(.brandSecondary)

                    if let rating = host.averageRating {
                        Label("\(rating, specifier: "%.1f")", systemImage: "star.fill")
                            .font(.caption)
                            .foregroundColor(.yellow)
                    }
                }
            }

            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4)
    }
}
