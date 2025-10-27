//
//  OnboardingPageView.swift
//  ofraud1
//
//  Created by Aislinn Gil on 23/10/25.
//

import SwiftUI

struct OnboardingPageView: View {
    let systemImage: String
    let title: String
    let description: String
    let gradientColors: [Color]

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            Image(systemName: systemImage)
                .font(.system(size: 120, weight: .thin))
                .foregroundStyle(
                    LinearGradient(
                        colors: gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .padding(.bottom, 20)

            Text(title)
                .font(.system(.title, design: .rounded, weight: .bold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Text(description)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .lineSpacing(5)

            Spacer()
            Spacer()
        }
    }
}

#Preview {
    OnboardingPageView(
        systemImage: "shield.checkered",
        title: "Bienvenido a Ofraud",
        description: "Tu comunidad contra el fraude digital. Reporta, consulta y protégete de estafas en línea.",
        gradientColors: [.brandPrimary, .brandSecondary]
    )
}
