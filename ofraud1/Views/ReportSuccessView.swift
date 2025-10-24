//
//  ReportSuccessView.swift
//  ofraud1
//
//  Created by Aislinn Gil on 16/10/25.
//

import SwiftUI

struct ReportSuccessView: View {
    let reportId: Int
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.systemBackground.ignoresSafeArea()

                VStack(spacing: 24) {
                    // Header
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                Text("Regresar")
                            }
                            .font(.body)
                            .foregroundColor(.primary)
                        }

                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top)

                    Spacer()

                    // Contenido principal
                    VStack(spacing: 20) {
                        Text("Reporte #\(String(format: "%04d", reportId))")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.primary)

                        VStack(spacing: 12) {
                            Text("¡Reporte exitoso!")
                                .font(.title2.bold())
                                .foregroundColor(.green)

                            Text("Podrás ver su seguimiento en la sección ")
                                .font(.body)
                                .foregroundColor(.primary)
                            + Text("\"Mi Perfil\"")
                                .font(.body.bold())
                                .foregroundColor(.red)
                            + Text(" en ")
                                .font(.body)
                                .foregroundColor(.primary)
                            + Text("\"Mis reportes\"")
                                .font(.body.bold())
                                .foregroundColor(.primary)
                        }
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)

                        Text("Puedes continuar con tu experiencia en la aplicación.")
                            .font(.body)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)

                        // Emoji de detective
                        Text("🕵️")
                            .font(.system(size: 120))
                            .padding(.top, 20)

                        // Logo Ofraud
                        Image("Ofraud")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200)
                            .padding(.top, 20)
                    }

                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ReportSuccessView(reportId: 1)
}
