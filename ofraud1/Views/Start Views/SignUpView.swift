//
//  SignUpView.swift
//  ofraud1
//
//  Created by Aislinn Gil on 30/09/25.
//

import SwiftUI
import RecaptchaEnterprise


struct SignUpView: View {
    // @State variables para cada campo del formulario
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var username = ""
    @State private var phoneNumber = ""
    @State private var password = ""
    @State private var agreedToTerms = false

    // Estados de validación y UI
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showError = false
    @State private var registrationSuccess = false
    @State private var showPrivacyPolicy = false
    @State private var showCommunityRules = false
    @Environment(\.dismiss) private var dismiss
    @StateObject private var recaptchaViewModel = RecaptchaViewModel()
    
    var isFormValid: Bool {
            firstName.isValidName &&
            lastName.isValidName &&
            email.isValidEmail &&
            username.count >= 3 &&
            phoneNumber.isValidPhoneNumber &&
            password.isValidPassword
        }
    // Authentication controller
    private let authController = AuthenticationController(httpClient: HTTPClient())

    var body: some View {
            ZStack {
                Color.systemBackground.ignoresSafeArea()
                
                Circle()
                    .fill(Color.brandSecondary.opacity(0.5))
                    .frame(width: 300)
                    .blur(radius: 120)
                    .offset(x: 150, y: -400)
                
                Circle()
                    .fill(Color.brandPrimary.opacity(0.5))
                    .frame(width: 250)
                    .blur(radius: 100)
                    .offset(x: -150, y: 400)

                ScrollView {
                    VStack(spacing: 24) {
                        
                        // --- TÍTULO ---
                        Text("Crear Cuenta")
                            .font(.largeTitle)

                        // --- FORMULARIO ---
                        VStack(alignment: .leading, spacing: 16) {
                            
                            // --- Nombre ---
                            Text("Nombre")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            TextField("Maria", text: $firstName)
                                .styledTextField() // Aplicamos el estilo de LoginView
                                .autocapitalization(.words)
                            if !firstName.isEmpty && !firstName.isValidName {
                                validationError("El nombre debe tener al menos 2 caracteres")
                            }

                            // --- Apellido ---
                            Text("Apellido")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            TextField("Canales", text: $lastName)
                                .styledTextField()
                                .autocapitalization(.words)
                            if !lastName.isEmpty && !lastName.isValidName {
                                validationError("El apellido debe tener al menos 2 caracteres")
                            }

                            // --- Correo ---
                            Text("Correo electrónico")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            TextField("maria@ejemplo.com", text: $email)
                                .styledTextField()
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                            if !email.isEmpty && !email.isValidEmail {
                                validationError("Por favor ingresa un correo válido")
                            }
                            
                            Text("Nombre de usuario")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            TextField("mariacanales01", text: $username)
                                .styledTextField()
                                .autocapitalization(.none)
                            if !username.isEmpty && username.count < 3 {
                                validationError("El usuario debe tener al menos 3 caracteres")
                            }

                            Text("Teléfono celular")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            TextField("5596969699", text: $phoneNumber)
                                .styledTextField()
                                .keyboardType(.phonePad)
                            if !phoneNumber.isEmpty && !phoneNumber.isValidPhoneNumber {
                                validationError("Por favor ingresa un teléfono válido (10-15 dígitos)")
                            }

                            Text("Contraseña")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            SecureField("***********", text: $password)
                                .styledTextField()
                            if !password.isEmpty && !password.isValidPassword {
                                validationError("La contraseña debe tener al menos 6 caracteres")
                            }
                        }
                        
                        HStack(alignment: .top, spacing: 12) {
                            Button(action: {
                                agreedToTerms.toggle() // Cambia el estado del check
                            }) {
                                Image(systemName: agreedToTerms ? "checkmark.square.fill" : "square")
                                    .font(.title2)
                                    .foregroundColor(agreedToTerms ? .brandPrimary : .gray)
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text("He leído y acepto los:")
                                    .font(.subheadline)
                                    .foregroundColor(.primary)

                                HStack(spacing: 4) {
                                    Button(action: {
                                        showPrivacyPolicy = true
                                    }) {
                                        Text("Avisos de Privacidad")
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .foregroundColor(.brandPrimary)
                                            .underline()
                                    }

                                    Text("y")
                                        .font(.subheadline)
                                        .foregroundColor(.primary)

                                    Button(action: {
                                        showCommunityRules = true
                                    }) {
                                        Text("Normas de Comunidad")
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .foregroundColor(.brandPrimary)
                                            .underline()
                                    }
                                }
                            }
                        }
                        .padding(.top, 10)

                        // --- BOTÓN DE ACEPTAR ---
                        Button(action: {
                            Task {
                                await registerUser()
                            }
                        }) {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Aceptar")
                            }
                        }
                        .buttonStyle(.styled) // Aplicamos el estilo de LoginView
                        .disabled(!isFormValid || !agreedToTerms || isLoading)
                        .padding(.top, 10)
                        
                        
                        Spacer() // Empuja el link de regreso al fondo
                        
                        // --- NAVEGACIÓN A LOGIN ---
                        HStack(spacing: 4) {
                            Text("¿Ya tienes una cuenta?")
                            Button(action: {
                                dismiss() // Cierra esta vista y regresa a Login
                            }) {
                                Text("Inicia Sesión")
                                    .fontWeight(.bold)
                                    .foregroundColor(.brandPrimary)
                            }
                        }
                        .font(.subheadline)
                        .padding(.vertical, 20)

                    }
                    .padding(.horizontal, 24)
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage ?? "Ocurrió un error al crear la cuenta")
            }
            .sheet(isPresented: $showPrivacyPolicy) {
                NavigationStack {
                    PrivacyPolicyView()
                        .navigationBarItems(trailing: Button("Cerrar") {
                            showPrivacyPolicy = false
                        })
                }
            }
            .sheet(isPresented: $showCommunityRules) {
                NavigationStack {
                    CommunityGuidelinesView()
                        .navigationBarItems(trailing: Button("Cerrar") {
                            showCommunityRules = false
                        })
                }
            }
        }
        
    
 
    
    func createTextField(title: String, placeholder: String, text: Binding<String>, keyboardType: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.custom("Poppins-Medium", size: 16))
                .foregroundColor(.secondary)
            
            TextField(placeholder, text: text)
                .font(.custom("Poppins-Regular", size: 16))
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .keyboardType(keyboardType)
                .autocapitalization(.words)
        }
    }
    
    func createSecureField(title: String, placeholder: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.custom("Poppins-Medium", size: 16))
                .foregroundColor(.secondary)

            SecureField(placeholder, text: text)
                .font(.custom("Poppins-Regular", size: 16))
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
        }
    }

    func validationError(_ message: String) -> some View {
        Text(message)
            .font(.custom("Poppins-Regular", size: 12))
            .foregroundColor(Color(red: 0.84, green: 0.09, blue: 0.03))
            .padding(.top, -12)
    }


    // --- FUNCIÓN DE REGISTRO ---
    func registerUser() async {
        isLoading = true
        errorMessage = nil

        // Intentar obtener token de reCAPTCHA (opcional durante desarrollo)
        do {
            let recaptchaToken = try await recaptchaViewModel.executeAction()
            print("✅ reCAPTCHA token obtenido: \(recaptchaToken.prefix(20))...")
        } catch {
            // Si reCAPTCHA falla, solo imprimimos warning pero continuamos
            print("⚠️ reCAPTCHA falló (continuando de todos modos): \(error.localizedDescription)")
        }

        // Continuar con el registro
        do {
            let success = try await authController.registerUser(
                email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                username: username.trimmingCharacters(in: .whitespacesAndNewlines),
                firstName: firstName.trimmingCharacters(in: .whitespacesAndNewlines),
                lastName: lastName.trimmingCharacters(in: .whitespacesAndNewlines),
                phoneNumber: phoneNumber.isEmpty ? nil : phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines),
                password: password
            )

            isLoading = false

            if success {
                registrationSuccess = true
                print("✅ Usuario registrado exitosamente")
                dismiss()
            } else {
                errorMessage = "No se pudo crear la cuenta. Por favor intenta de nuevo."
                showError = true
            }
        } catch {
            isLoading = false
            errorMessage = "Error: \(error.localizedDescription)"
            showError = true
            print("❌ Error al registrar usuario: \(error)")
        }
    }
}

#Preview {
    SignUpView()
}
