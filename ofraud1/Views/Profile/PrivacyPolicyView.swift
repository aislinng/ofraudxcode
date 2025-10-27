//
//  PrivacyPolicyView.swift
//  ofraud1
//
//  Created by Aislinn Gil on 23/10/25.
//

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ZStack {
            Color.systemBackground.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Avisos de Privacidad")
                            .font(.system(.largeTitle, design: .rounded, weight: .bold))

                        Text("Última actualización: 23 de octubre de 2025")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 10)

                    // Introduction
                    Text("En Ofraud, nos comprometemos a proteger tu privacidad y garantizar la seguridad de tu información personal. Esta política describe cómo recopilamos, usamos y protegemos tus datos.")
                        .font(.body)
                        .foregroundColor(.secondary)

                    Divider()

                    // Section 1
                    PolicySection(
                        number: "1",
                        title: "Información que Recopilamos",
                        icon: "doc.text.magnifyingglass",
                        content: "Recopilamos información que nos proporcionas al crear una cuenta, incluyendo nombre, apellido, correo electrónico, nombre de usuario y número de teléfono opcional. También recopilamos información sobre los reportes de fraude que compartes, incluyendo descripciones, categorías, URLs y evidencia fotográfica."
                    )

                    // Section 2
                    PolicySection(
                        number: "2",
                        title: "Cómo Usamos tu Información",
                        icon: "gearshape.2",
                        content: "Utilizamos tu información para: (1) proporcionar y mejorar nuestros servicios, (2) autenticar tu identidad y proteger tu cuenta, (3) procesar y publicar tus reportes de fraude, (4) generar estadísticas y análisis de fraude, (5) enviarte notificaciones importantes sobre el servicio, y (6) cumplir con requisitos legales."
                    )

                    // Section 3
                    PolicySection(
                        number: "3",
                        title: "Compartir Información",
                        icon: "person.2",
                        content: "Los reportes que publicas son visibles públicamente para ayudar a la comunidad a identificar fraudes. No vendemos tu información personal a terceros. Solo compartimos datos cuando es necesario para operar el servicio, cumplir con la ley, o proteger nuestros derechos y seguridad."
                    )

                    // Section 4
                    PolicySection(
                        number: "4",
                        title: "Seguridad de Datos",
                        icon: "lock.shield",
                        content: "Implementamos medidas de seguridad técnicas y organizativas para proteger tu información, incluyendo encriptación de contraseñas, conexiones HTTPS seguras, y controles de acceso estrictos. Sin embargo, ningún sistema es 100% seguro y no podemos garantizar seguridad absoluta."
                    )

                    // Section 5
                    PolicySection(
                        number: "5",
                        title: "Tus Derechos",
                        icon: "hand.raised",
                        content: "Tienes derecho a acceder, corregir o eliminar tu información personal. Puedes actualizar tu perfil en cualquier momento desde la configuración de tu cuenta. Para eliminar tu cuenta, contáctanos directamente. También puedes oponerte al procesamiento de tus datos bajo ciertas circunstancias."
                    )

                    // Section 6
                    PolicySection(
                        number: "6",
                        title: "Retención de Datos",
                        icon: "clock",
                        content: "Conservamos tu información personal mientras tu cuenta esté activa y durante un período razonable después para cumplir con obligaciones legales. Los reportes publicados pueden permanecer visibles incluso después de cerrar tu cuenta para mantener la integridad de la base de datos comunitaria."
                    )

                    // Section 7
                    PolicySection(
                        number: "7",
                        title: "Cambios a esta Política",
                        icon: "arrow.triangle.2.circlepath",
                        content: "Podemos actualizar esta política de privacidad ocasionalmente. Te notificaremos sobre cambios significativos publicando la nueva política en la aplicación y actualizando la fecha de 'última actualización'. Te recomendamos revisar esta política periódicamente."
                    )

                    // Contact
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Contacto")
                            .font(.headline)
                            .foregroundColor(.brandPrimary)

                        Text("Si tienes preguntas sobre esta política de privacidad, contáctanos en: privacy@ofraud.com")
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

struct PolicySection: View {
    let number: String
    let title: String
    let icon: String
    let content: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.brandPrimary)
                        .frame(width: 36, height: 36)

                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                }

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

#Preview {
    NavigationStack {
        PrivacyPolicyView()
    }
}
