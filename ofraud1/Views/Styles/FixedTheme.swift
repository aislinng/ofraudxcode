//
//  FixedTheme.swift
//  ofraud1
//
//  Created by Aislinn Gil on 07/10/25.
//

import Foundation
import SwiftUI

struct StyledTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.body)
            .padding()
            .background(Color.secondarySystemBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.tertiarySystemBackground, lineWidth: 1)
            )
    }
}

// Extensión para que sea más fácil de llamar
extension View {
    func styledTextField() -> some View {
        self.modifier(StyledTextFieldModifier())
    }
}
