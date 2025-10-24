//
//  EditProfileView.swift
//  ofraud1
//
//  Created by Aislinn Gil 23/10/25.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var firstName: String
    @State private var lastName: String
    @State private var username: String
    @State private var phoneNumber: String

    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showError = false
    @State private var showSuccess = false

    let currentUser: User
    private let httpClient = HTTPClient()

    init(user: User) {
        self.currentUser = user
        _firstName = State(initialValue: user.firstName)
        _lastName = State(initialValue: user.lastName)
        _username = State(initialValue: user.username)
        _phoneNumber = State(initialValue: user.phoneNumber ?? "")
    }

    var isFormValid: Bool {
        firstName.isValidName &&
        lastName.isValidName &&
        username.count >= 3 &&
        (phoneNumber.isEmpty || phoneNumber.isValidPhoneNumber)
    }

    var hasChanges: Bool {
        firstName != currentUser.firstName ||
        lastName != currentUser.lastName ||
        username != currentUser.username ||
        phoneNumber != (currentUser.phoneNumber ?? "")
    }

    var body: some View {
        ZStack {
            Color.systemBackground.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.brandPrimary)

                        Text("Editar Perfil")
                            .font(.title.bold())
                    }
                    .padding(.top)

                    // Form
                    VStack(spacing: 20) {
                        // Email (read-only)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Correo electrónico")
                                .font(.headline)
                                .foregroundColor(.secondary)

                            HStack {
                                Text(currentUser.email)
                                    .foregroundColor(.secondary)

                                Spacer()

                                Image(systemName: "lock.fill")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)

                            Text("El correo electrónico no se puede modificar")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        // First Name
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Nombre")
                                .font(.headline)
                                .foregroundColor(.secondary)

                            TextField("Nombre", text: $firstName)
                                .styledTextField()
                                .autocapitalization(.words)

                            if !firstName.isEmpty && !firstName.isValidName {
                                ValidationError(message: "El nombre debe tener al menos 2 caracteres")
                            }
                        }

                        // Last Name
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Apellido")
                                .font(.headline)
                                .foregroundColor(.secondary)

                            TextField("Apellido", text: $lastName)
                                .styledTextField()
                                .autocapitalization(.words)

                            if !lastName.isEmpty && !lastName.isValidName {
                                ValidationError(message: "El apellido debe tener al menos 2 caracteres")
                            }
                        }

                        // Username
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Nombre de usuario")
                                .font(.headline)
                                .foregroundColor(.secondary)

                            TextField("Nombre de usuario", text: $username)
                                .styledTextField()
                                .autocapitalization(.none)

                            if !username.isEmpty && username.count < 3 {
                                ValidationError(message: "El usuario debe tener al menos 3 caracteres")
                            }
                        }

                        // Phone Number
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Teléfono celular (opcional)")
                                .font(.headline)
                                .foregroundColor(.secondary)

                            TextField("Teléfono", text: $phoneNumber)
                                .styledTextField()
                                .keyboardType(.phonePad)

                            if !phoneNumber.isEmpty && !phoneNumber.isValidPhoneNumber {
                                ValidationError(message: "Por favor ingresa un teléfono válido")
                            }
                        }
                    }
                    .padding(.horizontal)

                    // Save Button
                    Button(action: {
                        Task {
                            await updateProfile()
                        }
                    }) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Guardar Cambios")
                        }
                    }
                    .buttonStyle(.styled)
                    .disabled(!isFormValid || !hasChanges || isLoading)
                    .padding(.horizontal)

                    if !hasChanges {
                        Text("No hay cambios para guardar")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical)
            }
        }
        .navigationTitle("Editar Perfil")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage ?? "Ocurrió un error al actualizar el perfil")
        }
        .alert("Éxito", isPresented: $showSuccess) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        } message: {
            Text("Tu perfil se ha actualizado correctamente")
        }
    }

    func updateProfile() async {
        isLoading = true
        errorMessage = nil

        do {
            let dto = UpdateUserProfileDto(
                firstName: firstName.trimmingCharacters(in: .whitespacesAndNewlines),
                lastName: lastName.trimmingCharacters(in: .whitespacesAndNewlines),
                username: username.trimmingCharacters(in: .whitespacesAndNewlines),
                phoneNumber: phoneNumber.isEmpty ? nil : phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines),
                profilePicture: nil
            )

            _ = try await httpClient.updateUserProfile(dto: dto)

            isLoading = false
            showSuccess = true

        } catch {
            isLoading = false
            errorMessage = "Error: \(error.localizedDescription)"
            showError = true
            print("Error al actualizar perfil: \(error)")
        }
    }
}

struct ValidationError: View {
    let message: String

    var body: some View {
        Text(message)
            .font(.caption)
            .foregroundColor(.red)
    }
}

#Preview {
    NavigationStack {
        EditProfileView(user: User(
            id: 1,
            email: "test@example.com",
            username: "testuser",
            firstName: "Juan",
            lastName: "Pérez",
            phoneNumber: "1234567890",
            role: .user,
            isBlocked: false,
            blockedReason: nil,
            blockedBy: nil,
            blockedAt: nil,
            profilePicture: nil
        ))
    }
}
