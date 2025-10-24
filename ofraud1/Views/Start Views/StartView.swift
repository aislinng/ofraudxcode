//
//  StartView.swift
//  ofraud1
//
//  Created by Aislinn Gil on 30/09/25.
//

// StartView.swift
import SwiftUI

struct StartView: View {
    var body: some View {
        ZStack {
            Color.systemBackground.ignoresSafeArea()
            
            Circle()
                .fill(Color.brandSecondary.opacity(0.5))
                .frame(width: 250)
                .blur(radius: 100)
                .offset(x: -150, y: -350)
            
            Circle()
                .fill(Color.brandPrimary.opacity(0.4))
                .frame(width: 300)
                .blur(radius: 120)
                .offset(x: 150, y: 300)
            
            VStack(spacing: 20) {
                VStack(spacing: 30) {
                    
                    Image("Ofraud")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 400)
                    
                    Text("¡La red social para la detección de fraudes!")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
        }
    }
}

#Preview {
    StartView()
}
