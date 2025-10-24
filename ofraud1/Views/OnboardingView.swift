//
//  OnboardingView.swift
//  ofraud1
//
//  Created by Aislinn Gil on 23/10/25.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0

    let pages: [(systemImage: String, title: String, description: String, gradientColors: [Color])] = [
        (
            systemImage: "shield.checkered",
            title: "Bienvenido a Ofraud",
            description: "Tu comunidad contra el fraude digital. Reporta, consulta y protégete de estafas en línea.",
            gradientColors: [.brandPrimary, .brandSecondary]
        ),
        (
            systemImage: "exclamationmark.bubble",
            title: "Reporta fraudes",
            description: "¿Detectaste una estafa? Compártela con la comunidad. Ayuda a otros a no caer en el mismo engaño.",
            gradientColors: [.brandSecondary, .orange]
        ),
        (
            systemImage: "hands.and.sparkles",
            title: "Mantente protegido",
            description: "Consulta reportes de otros usuarios, aprende sobre fraudes comunes y protégete en línea.",
            gradientColors: [.orange, .brandPrimary]
        )
    ]

    var body: some View {
        ZStack {
            Color.systemBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                // Skip button
                HStack {
                    Spacer()
                    if currentPage < pages.count - 1 {
                        Button(action: {
                            withAnimation {
                                showOnboarding = false
                            }
                        }) {
                            Text("Saltar")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                    }
                }

                // Pages with TabView
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(
                            systemImage: pages[index].systemImage,
                            title: pages[index].title,
                            description: pages[index].description,
                            gradientColors: pages[index].gradientColors
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))

                // Bottom button
                if currentPage == pages.count - 1 {
                    Button(action: {
                        withAnimation {
                            showOnboarding = false
                        }
                    }) {
                        Text("Comenzar")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [.brandPrimary, .brandSecondary],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                } else {
                    Color.clear
                        .frame(height: 100)
                }
            }
        }
    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
