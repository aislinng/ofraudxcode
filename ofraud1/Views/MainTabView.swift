//
//  MainTabView.swift
//  ofraud1
//
//  Created by Aislinn Gil on 16/10/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Inicio")
                }
                .tag(0)

            // Tab 2: Insights
            InsightsView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "star.fill" : "star")
                    Text("Insights")
                }
                .tag(1)

            // Tab 3: Reportar
            CreateReportView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "plus.circle.fill" : "plus.circle")
                    Text("Reportar")
                }
                .tag(2)

            // Tab 4: Mi Perfil
            ProfileView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "person.fill" : "person")
                    Text("Mi perfil")
                }
                .tag(3)
        }
        .accentColor(.brandPrimary)
    }
}

#Preview {
    MainTabView()
}
