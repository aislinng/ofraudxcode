//
//  ProfileView.swift
//  ofraud1
//
//  Created by Aislinn Gil on 16/10/25.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showingLogoutAlert = false
    @State private var currentUser: User?
    @State private var isLoading = true
    @State private var errorMessage: String?

    // Estados para manejo de fotos (basado en código de clase)
    @State private var selectedUIImage: UIImage?
    @State private var showCamera = false
    @State private var photoPickerItem: PhotosPickerItem?
    @State private var uploadStatus: String?
    @State private var showPhotoOptions = false

    private let httpClient = HTTPClient()

    var body: some View {
        NavigationStack {
            ZStack {
                Color.systemBackground.ignoresSafeArea()

                if isLoading {
                    ProgressView("Cargando perfil...")
                } else if let errorMessage = errorMessage {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text(errorMessage)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        Button("Reintentar") {
                            Task {
                                await loadUserProfile()
                            }
                        }
                        .buttonStyle(.styled)
                    }
                    .padding()
                } else if let user = currentUser {
                    ScrollView {
                        VStack(spacing: 24) {
                            // Header con avatar
                            VStack(spacing: 16) {
                                // Logo
                                Image("Ofraud")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 50)

                                Text("Mi perfil")
                                    .font(.title.bold())

                                // Avatar del usuario con opción de cambiar foto
                                ZStack(alignment: .bottomTrailing) {
                                    Group {
                                        if let selectedUIImage = selectedUIImage {
                                            // Mostrar imagen seleccionada
                                            Image(uiImage: selectedUIImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 100, height: 100)
                                                .clipShape(Circle())
                                        } else if let profilePicture = user.profilePicture,
                                                  let url = URL(string: "\(URLEndpoints.server)\(profilePicture)") {
                                            // Mostrar foto de perfil del servidor
                                            AsyncImage(url: url) { phase in
                                                switch phase {
                                                case .empty:
                                                    ProgressView()
                                                        .frame(width: 100, height: 100)
                                                case .success(let image):
                                                    image
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 100, height: 100)
                                                        .clipShape(Circle())
                                                case .failure:
                                                    // Si falla, mostrar icono por defecto
                                                    Image(systemName: "person.crop.circle.fill")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 100, height: 100)
                                                        .foregroundColor(.brandPrimary)
                                                @unknown default:
                                                    EmptyView()
                                                }
                                            }
                                        } else {
                                            // Avatar por defecto
                                            Image(systemName: "person.crop.circle.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 100, height: 100)
                                                .foregroundColor(.brandPrimary)
                                        }
                                    }

                                    // Botón para cambiar foto
                                    Button {
                                        showPhotoOptions = true
                                    } label: {
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 14))
                                            .foregroundColor(.white)
                                            .frame(width: 32, height: 32)
                                            .background(Color.brandPrimary)
                                            .clipShape(Circle())
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.white, lineWidth: 2)
                                            )
                                    }
                                }

                                // Estado de la subida
                                if let status = uploadStatus {
                                    Text(status)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }

                                // User info
                                VStack(spacing: 4) {
                                    Text(user.fullName)
                                        .font(.title3.bold())
                                    Text("@\(user.username)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.top)

                            // Opciones del menú
                            VStack(spacing: 12) {
                                NavigationLink(destination: EditProfileView(user: user)) {
                                    ProfileMenuButton(
                                        title: "Datos Personales",
                                        icon: "person.text.rectangle"
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())

                                NavigationLink(destination: MyReportsView()) {
                                    ProfileMenuButton(
                                        title: "Mis Reportes",
                                        icon: "doc.text"
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())

                                NavigationLink(destination: PrivacyPolicyView()) {
                                    ProfileMenuButton(
                                        title: "Avisos de Privacidad",
                                        icon: "lock.shield"
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())

                                NavigationLink(destination: CommunityGuidelinesView()) {
                                    ProfileMenuButton(
                                        title: "Normas de Comunidad",
                                        icon: "doc.plaintext"
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(.horizontal)

                            // Botón de cerrar sesión
                            Button(action: {
                                showingLogoutAlert = true
                            }) {
                                Text("Cerrar Sesión")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.brandSecondary)
                                    .cornerRadius(12)
                            }
                            .padding(.horizontal)
                            .padding(.top, 20)
                        }
                        .padding(.vertical)
                    }
                    .refreshable {
                        await loadUserProfile()
                    }
                }
            }
            .task {
                await loadUserProfile()
            }
            .alert("Cerrar Sesión", isPresented: $showingLogoutAlert) {
                Button("Cancelar", role: .cancel) { }
                Button("Cerrar Sesión", role: .destructive) {
                    authViewModel.logout()
                }
            } message: {
                Text("¿Estás seguro que deseas cerrar sesión?")
            }
            // Sheet para opciones de foto (basado en código de clase)
            .confirmationDialog("Cambiar foto de perfil", isPresented: $showPhotoOptions) {
                Button("Cámara") {
                    showCamera = true
                }
                .disabled(!UIImagePickerController.isSourceTypeAvailable(.camera))

                PhotosPicker(selection: $photoPickerItem, matching: .images) {
                    Text("Rollo")
                }

                Button("Cancelar", role: .cancel) { }
            }
            // Sheet para la cámara
            .sheet(isPresented: $showCamera) {
                CameraPicker(image: $selectedUIImage)
                    .ignoresSafeArea()
            }
            // onChange para PhotosPicker (basado en código de clase)
            .onChange(of: photoPickerItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        selectedUIImage = uiImage
                    }
                }
            }
            // onChange para subir la imagen cuando se selecciona
            .onChange(of: selectedUIImage) { _, newImage in
                if let image = newImage {
                    Task {
                        await uploadProfilePicture(image)
                    }
                }
            }
        }
    }

    func loadUserProfile() async {
        isLoading = true
        errorMessage = nil

        do {
            currentUser = try await httpClient.getCurrentUser()
            isLoading = false
        } catch {
            // Si es un error 401, hacer logout automáticamente
            if let nsError = error as NSError?, nsError.code == 401 {
                print("⚠️ [ProfileView] Token inválido - cerrando sesión")
                await MainActor.run {
                    authViewModel.logout()
                }
            } else {
                errorMessage = "Error al cargar el perfil: \(error.localizedDescription)"
            }
            isLoading = false
        }
    }

    /// Función para subir foto de perfil al servidor (basado en código de clase)
    func uploadProfilePicture(_ image: UIImage) async {
        uploadStatus = "Subiendo imagen..."

        do {
            let updatedUser = try await httpClient.updateProfilePicture(image: image)
            await MainActor.run {
                currentUser = updatedUser
                uploadStatus = "Imagen actualizada con éxito ✅"
            }
            // Limpiar el mensaje después de 3 segundos
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            await MainActor.run {
                uploadStatus = nil
            }
        } catch {
            await MainActor.run {
                uploadStatus = "Error al subir imagen ❌"
            }
            // Limpiar el mensaje después de 3 segundos
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            await MainActor.run {
                uploadStatus = nil
                selectedUIImage = nil // Limpiar imagen seleccionada si falla
            }
        }
    }
}

struct ProfileMenuButton: View {
    let title: String
    let icon: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.brandPrimary)
                .frame(width: 30)

            Text(title)
                .font(.body)
                .foregroundColor(.primary)

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4)
    }
}

#Preview {
    ProfileView()
}
