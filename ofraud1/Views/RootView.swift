//
//  RootView.swift
//  ofraud1
//
//  Created by Aislinn Gil on 07/10/25.
//

import SwiftUI

struct RootView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var showSplash = true

    var body: some View {
        ZStack {
            if showSplash {
                StartView()
                    .transition(.opacity)
            } else {
                if authViewModel.isAuthenticated {
                    if authViewModel.showOnboarding {
                        OnboardingView(showOnboarding: $authViewModel.showOnboarding)
                            .transition(.opacity)
                            .onChange(of: authViewModel.showOnboarding) { newValue in
                                if !newValue {
                                    authViewModel.completeOnboarding()
                                }
                            }
                    } else {
                        MainTabView()
                            .environmentObject(authViewModel)
                            .transition(.opacity)
                    }
                } else {
                    NavigationStack {
                        LoginView()
                            .environmentObject(authViewModel)
                    }
                    .transition(.opacity)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showSplash = false
                }
            }
        }
    }
}

#Preview {
    RootView()
}
