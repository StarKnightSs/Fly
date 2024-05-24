//
// FileExtension.swift
// Created by Arpit Williams on 24/05/24.
// Copyright (c) 2024 StarKnights Technologies

import FileServer
import QuickLookThumbnailing
import UIKit

// MARK: - QuickLook Preview

public extension File {

  @MainActor
  func generatePreviewIcon() async throws -> UIImage {
    let request = QLThumbnailGenerator.Request(
      fileAt: url,
      size: CGSize(width: 60, height: 60),
      scale: UIScreen.main.scale,
      representationTypes: .all
    )
    let generator = QLThumbnailGenerator.shared
    return try await generator.generateBestRepresentation(for: request).uiImage
  }
}
