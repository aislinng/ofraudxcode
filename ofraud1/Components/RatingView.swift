//
//  RatingView.swift
//  ofraud1
//
//  Created by Aislinn Gil on 23/10/25.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Int
    let maxRating: Int = 5
    let onColor: Color = .yellow
    let offColor: Color = .gray.opacity(0.3)
    let interactive: Bool

    init(rating: Binding<Int>, interactive: Bool = true) {
        self._rating = rating
        self.interactive = interactive
    }

    var body: some View {
        HStack(spacing: 8) {
            ForEach(1...maxRating, id: \.self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .font(.title2)
                    .foregroundColor(index <= rating ? onColor : offColor)
                    .onTapGesture {
                        if interactive {
                            rating = index
                        }
                    }
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        Text("Califica este reporte")
            .font(.headline)

        RatingView(rating: .constant(3), interactive: true)

        RatingView(rating: .constant(5), interactive: false)
    }
    .padding()
}
