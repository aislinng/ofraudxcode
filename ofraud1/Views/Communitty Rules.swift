//
//  Communitty Rules.swift
//  ofraud1
//
//  Created by Aislinn Gil on 23/10/25.
//

import SwiftUI

struct CommunityGuidelinesView: View {
    var body: some View {
        ZStack {
            Color.systemBackground.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Normas de la Comunidad")
                            .font(.system(.largeTitle, design: .rounded, weight: .bold))

                        Text("Última actualización: 23 de octubre de 2025")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 10)

                    // Introduction
                    Text("Bienvenido a Ofraud. Nuestra comunidad se dedica a combatir el fraude y proteger a los usuarios. Para mantener un ambiente seguro, constructivo y respetuoso, todos los miembros deben seguir estas normas:")
                        .font(.body)
                        .foregroundColor(.secondary)

                    Divider()

                    // Rule 1
                    GuidelineSection(
                        number: "1",
                        title: "Sé Respetuoso y Profesional",
                        icon: "heart.circle",
                        content: "Trata a todos los miembros de la comunidad con dignidad y respeto. No se tolerará el acoso, la intimidación, el discurso de odio, ni ningún tipo de discriminación basada en raza, género, orientación sexual, religión, nacionalidad o discapacidad."
                    )

                    // Rule 2
                    GuidelineSection(
                        number: "2",
                        title: "Publica Información Veraz",
                        icon: "checkmark.shield",
                        content: "Solo publica reportes de fraude que sean verídicos y basados en tu experiencia real. Verifica la información antes de compartirla. La desinformación deliberada, difamación o acusaciones falsas con el fin de dañar a una persona o entidad resultarán en suspensión inmediata."
                    )

                    // Rule 3
                    GuidelineSection(
                        number: "3",
                        title: "Protege la Privacidad",
                        icon: "lock.circle",
                        content: "No compartas información personal privada de otras personas (doxing) sin su consentimiento explícito. Esto incluye direcciones físicas, números de teléfono personales, documentos de identidad, o cualquier dato sensible que no sea necesario para documentar el fraude."
                    )

                    // Rule 4
                    GuidelineSection(
                        number: "4",
                        title: "Proporciona Evidencia",
                        icon: "doc.text.image",
                        content: "Siempre que sea posible, respalda tus reportes con evidencia verificable como capturas de pantalla, URLs, correos electrónicos, o fotografías. La evidencia fortalece la credibilidad de tu reporte y ayuda a otros a identificar fraudes similares."
                    )

                    // Rule 5
                    GuidelineSection(
                        number: "5",
                        title: "No Promuevas Contenido Ilegal",
                        icon: "exclamationmark.triangle",
                        content: "Está prohibido publicar, promover o compartir contenido ilegal, incluyendo actividades fraudulentas, esquemas piramidales, venta de productos falsificados, o cualquier actividad que viole las leyes locales, nacionales o internacionales."
                    )

                    // Rule 6
                    GuidelineSection(
                        number: "6",
                        title: "Usa las Categorías Correctas",
                        icon: "folder",
                        content: "Clasifica tus reportes en la categoría apropiada (phishing, estafa telefónica, fraude en línea, etc.). Esto ayuda a la comunidad a encontrar y entender mejor los diferentes tipos de fraude. Si no estás seguro, elige la categoría más cercana."
                    )

                    // Rule 7
                    GuidelineSection(
                        number: "7",
                        title: "No Abuses del Sistema",
                        icon: "hand.raised.circle",
                        content: "No publiques spam, contenido duplicado, o reportes excesivos sobre el mismo incidente. No intentes manipular el sistema, crear múltiples cuentas, o realizar ataques coordinados contra usuarios o entidades específicas."
                    )

                    // Rule 8
                    GuidelineSection(
                        number: "8",
                        title: "Reporta Violaciones",
                        icon: "flag.circle",
                        content: "Si observas contenido que viola estas normas, repórtalo inmediatamente a los moderadores. No tomes represalias por tu cuenta. Nuestro equipo revisará todos los reportes y tomará las acciones apropiadas."
                    )

                    // Consequences
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 12) {
                            Image(systemName: "exclamationmark.shield")
                                .font(.title2)
                                .foregroundColor(.brandSecondary)

                            Text("Consecuencias")
                                .font(.title3.bold())
                                .foregroundColor(.brandSecondary)
                        }

                        Text("Las violaciones a estas normas pueden resultar en:")
                            .font(.body.bold())

                        VStack(alignment: .leading, spacing: 8) {
                            ConsequenceItem(text: "Advertencia oficial")
                            ConsequenceItem(text: "Eliminación de contenido")
                            ConsequenceItem(text: "Suspensión temporal de la cuenta")
                            ConsequenceItem(text: "Bloqueo permanente de la cuenta")
                            ConsequenceItem(text: "Reporte a las autoridades (en casos graves)")
                        }
                    }
                    .padding()
                    .background(Color.brandSecondary.opacity(0.1))
                    .cornerRadius(12)

                    // Contact
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Contacto de Moderación")
                            .font(.headline)
                            .foregroundColor(.brandPrimary)

                        Text("Si tienes preguntas sobre estas normas o necesitas reportar una violación, contáctanos en: moderation@ofraud.com")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.brandPrimary.opacity(0.1))
                    .cornerRadius(12)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct GuidelineSection: View {
    let number: String
    let title: String
    let icon: String
    let content: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.brandPrimary)
                    .frame(width: 36)

                Text("\(number). \(title)")
                    .font(.title3.bold())
                    .foregroundColor(.brandPrimary)
            }

            Text(content)
                .font(.body)
                .foregroundColor(.primary)
                .lineSpacing(4)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4)
    }
}

struct ConsequenceItem: View {
    let text: String

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(Color.brandSecondary)
                .frame(width: 6, height: 6)

            Text(text)
                .font(.body)
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    NavigationStack {
        CommunityGuidelinesView()
    }
}
