//
// PhotosPicker.swift
// Created by Arpit Williams on 28/05/24.
// Copyright (c) 2024 StarKnights Technologies

import FlyServer
import PhotosUI
import SwiftUI

struct PhotosPicker: UIViewControllerRepresentable {

  let filesManager: FilesManagerProtocol
  var onCompletion: ([URL]) -> Void

  func makeUIViewController(context: Context) -> PHPickerViewController {
    var configuration = PHPickerConfiguration()
    configuration.selectionLimit = 0
    configuration.preferredAssetRepresentationMode = .current
    let picker = PHPickerViewController(configuration: configuration)
    picker.delegate = context.coordinator
    return picker
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(filesManager: filesManager, onCompletion: onCompletion)
  }

  func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
}

extension PhotosPicker {

  final class Coordinator: NSObject, PHPickerViewControllerDelegate {

    let filesManager: FilesManagerProtocol
    let onCompletion: ([URL]) -> Void

    init(filesManager: FilesManagerProtocol, onCompletion: @escaping ([URL]) -> Void) {
      self.filesManager = filesManager
      self.onCompletion = onCompletion
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      picker.dismiss(animated: true)
      Task(priority: .high) {
        var urls = [URL]()
        for result in results {
          do {
            let itemProvider = result.itemProvider
            let type = try getSupportedType(for: itemProvider)
            let url = try await loadFile(of: type, with: itemProvider)
            urls.append(url)
          } catch {
            print(error)
          }
        }
        await MainActor.run {
          onCompletion(urls)
        }
      }
    }

    private func getSupportedType(for provider: NSItemProvider) throws -> UTType {
      let supportTypes: [UTType] = [.image, .movie, .video, .audio, .livePhoto]
      for type in supportTypes where provider.hasRepresentationConforming(toTypeIdentifier: type.identifier) {
        return type
      }
      throw FileError.fileTypeNotSupported
    }

    private func loadFile(of type: UTType, with itemProvider: NSItemProvider) async throws -> URL {
      try await withCheckedThrowingContinuation { continuation in
        itemProvider.loadFileRepresentation(
          forTypeIdentifier: type.identifier
        ) { [weak self] url, error in
          do {
            guard let url, error == nil else {
              throw error ?? FileError.fileLoadingError
            }
            let fileName = url.lastPathComponent
            guard let filePath = try self?.filesManager.overwriteFilePath(for: fileName) else {
              throw FileError.filePathInvalid
            }
            try self?.filesManager.copy(from: url, to: filePath)
            continuation.resume(returning: filePath)
          } catch {
            continuation.resume(throwing: error)
          }
        }
      }
    }
  }
}
