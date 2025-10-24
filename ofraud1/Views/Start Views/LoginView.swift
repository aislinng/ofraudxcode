//
//  LoginView.swift
//  ofraud1
//
//  Created by Aislinn Gil on 30/09/25.
//
// LoginView.swift

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showError = false

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
                    
                    HStack {
                        Image(systemName: "magnifyingglass.circle.fill")
                            .font(.system(size: 44, weight: .bold))
                            .foregroundStyle(
                                .linearGradient(
                                    colors: [.brandSecondary, .brandPrimary],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        Text("Ofraud")
                            .font(.system(.largeTitle, design: .rounded, weight: .bold))
                            .foregroundColor(.primary)
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                    
                    Text("Inicia Sesión")
                        .font(.system(.title, design: .rounded, weight: .bold))
                        .foregroundColor(.primary)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Correo electrónico")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        TextField("tu.correo@ejemplo.com", text: $email)
                            .styledTextField()
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .autocapitalization(.none)
                        
                        Text("Contraseña")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        SecureField("Contraseña", text: $password)
                            .styledTextField()
                            .textContentType(.password)
                    }
                    
                    Spacer().frame(height: 20)
                    
                    Button(action: {
                        Task {
                            await loginUser()
                        }
                    }) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Aceptar")
                        }
                    }
                    .buttonStyle(.styled)
                    .disabled(isLoading || email.isEmpty || password.isEmpty)
                    
                    
                    Spacer()
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Text("¿Aún no tienes una cuenta?")
                        NavigationLink(destination: SignUpView()) {
                            Text("Regístrate ")
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
        .alert("Error de autenticación", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage ?? "No se pudo iniciar sesión. Verifica tus credenciales.")
        }
    }

    // MARK: - Login Function
    func loginUser() async {
        print("[LoginView] ========== INICIO DE LOGIN ==========")
        print("[LoginView] Email ingresado: \(email)")
        print("[LoginView] Password length: \(password.count)")

        isLoading = true
        errorMessage = nil
        print("[LoginView] isLoading = true")

        do {
            print(" [LoginView] Llamando a authViewModel.login()...")
            let success = try await authViewModel.login(
                email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                password: password
            )

            print(" [LoginView] authViewModel.login() completado con success: \(success)")
            isLoading = false
            print(" [LoginView] isLoading = false")

            if success {
                // Login exitoso - AuthViewModel actualizará isAuthenticated
                // y RootView mostrará automáticamente MainTabView
                print(" [LoginView] Login exitoso! Esperando navegación...")
                print(" [LoginView] authViewModel.isAuthenticated = \(authViewModel.isAuthenticated)")
            } else {
                print(" [LoginView] Login falló - success = false")
                errorMessage = "Credenciales incorrectas. Por favor intenta de nuevo."
                showError = true
                print(" [LoginView] Mostrando alerta de error")
            }
        } catch {
            print(" [LoginView] Exception capturada en loginUser")
            print(" [LoginView] Error: \(error)")
            print(" [LoginView] LocalizedDescription: \(error.localizedDescription)")

            isLoading = false
            errorMessage = "Error de conexión: \(error.localizedDescription)"
            showError = true
            print(" [LoginView] Mostrando alerta de error de conexión")
        }

        print(" [LoginView] ========== FIN DE LOGIN ==========")
    }
}

#Preview {
    LoginView()
}
