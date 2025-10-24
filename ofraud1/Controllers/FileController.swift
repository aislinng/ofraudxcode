//
//  FileController.swift
//  ofraud1
//
//  Created by Aislinn Gil on 16/10/25.
//

import Foundation
import UIKit

struct FileController {
    let httpClient: HTTPClient

    func uploadImage(image: UIImage) async throws -> FileUploadResponse {
        return try await httpClient.uploadImage(image: image)
    }
}
