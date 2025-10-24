//
//  ButtonStyle.swift
//  ofraud1
//
//  Created by Aislinn Gil on 07/10/25.
//

import Foundation
import SwiftUI

struct StyledButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.weight(.semibold))
            .padding()
            .foregroundColor(.white)
            .background(configuration.isPressed ? Color.brandSecondary : Color.brandPrimary)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .shadow(color: .brandPrimary.opacity(0.4), radius: 10, y: 5)
    }
}

extension ButtonStyle where Self == StyledButtonStyle {
    static var styled: StyledButtonStyle {
        .init()
    }
}
