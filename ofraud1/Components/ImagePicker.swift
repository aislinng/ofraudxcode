//
//  ImagePicker.swift
//  ofraud1
//
//  Created by Aislinn Gil on 16/10/25.
//

import SwiftUI
import PhotosUI
import UIKit

struct ImagePicker: View {
    @Binding var selectedImages: [UIImage]
    let maxImages: Int = 5

    @State private var showCamera = false
    @State private var photoPickerItem: PhotosPickerItem?
    @State private var selectedItems: [PhotosPickerItem] = []

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                Button {
                    showCamera = true
                } label: {
                    Label("Cámara", systemImage: "camera.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!UIImagePickerController.isSourceTypeAvailable(.camera) || selectedImages.count >= maxImages)

                PhotosPicker(selection: $selectedItems, maxSelectionCount: maxImages, matching: .images) {
                    Label("Rollo", systemImage: "photo.on.rectangle")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .disabled(selectedImages.count >= maxImages)
            }

            if !selectedImages.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(Array(selectedImages.enumerated()), id: \.offset) { index, image in
                            ZStack(alignment: .topTrailing) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .shadow(radius: 4)

                                Button(action: {
                                    selectedImages.remove(at: index)
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.white)
                                        .background(Color.black.opacity(0.6))
                                        .clipShape(Circle())
                                }
                                .padding(4)
                            }
                        }
                    }
                }
            } else {
                ContentUnavailableView(
                    "Sin imágenes",
                    systemImage: "photo",
                    description: Text("Elige fotos del rollo o toma una con la cámara.")
                )
                .frame(height: 120)
            }

            Text("Imágenes: \(selectedImages.count)/\(maxImages)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .sheet(isPresented: $showCamera) {
            CameraPicker(image: Binding(
                get: { nil },
                set: { newImage in
                    if let newImage = newImage, selectedImages.count < maxImages {
                        selectedImages.append(newImage)
                    }
                }
            ))
            .ignoresSafeArea()
        }
        .onChange(of: selectedItems) { _, newItems in
            Task {
                print("🖼️ [ImagePicker] onChange triggered - Nuevos items: \(newItems.count)")

                // No resetear el array, solo cargar las nuevas imágenes seleccionadas
                var newImages: [UIImage] = []

                for (index, item) in newItems.enumerated() {
                    print("🖼️ [ImagePicker] Cargando imagen \(index + 1)/\(newItems.count)")

                    if let data = try? await item.loadTransferable(type: Data.self) {
                        print("🖼️ [ImagePicker] Data cargada: \(data.count) bytes")

                        if let uiImage = UIImage(data: data) {
                            print("✅ [ImagePicker] Imagen \(index + 1) convertida exitosamente")
                            newImages.append(uiImage)
                        } else {
                            print("❌ [ImagePicker] Error: No se pudo convertir data a UIImage")
                        }
                    } else {
                        print("❌ [ImagePicker] Error: No se pudo cargar transferable data")
                    }
                }

                print("🖼️ [ImagePicker] Total imágenes cargadas: \(newImages.count)")

                // Reemplazar con las nuevas imágenes (PhotosPicker maneja la selección completa)
                selectedImages = newImages

                print("✅ [ImagePicker] selectedImages actualizado: \(selectedImages.count) imágenes")
            }
        }
    }
}

/// Envoltura de UIKit para la cámara (como en clase)
struct CameraPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraPicker
        init(_ parent: CameraPicker) { self.parent = parent }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
