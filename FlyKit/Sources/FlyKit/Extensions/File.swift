//
// File.swift
// Created by Arpit Williams on 08/06/24.
// Copyright (c) 2024 StarKnights Technologies

import FlyServer
import QuickLookThumbnailing
import UIKit

// MARK: - QuickLook Preview

public extension File {

  @MainActor
  func generatePreviewIcon() async throws -> UIImage {
    let request = QLThumbnailGenerator.Request(
      fileAt: url,
      size: CGSize(width: 44, height: 44),
      scale: UIScreen.main.scale,
      representationTypes: .thumbnail
    )
    let generator = QLThumbnailGenerator.shared
    return try await generator.generateBestRepresentation(for: request).uiImage
  }

  var icon: String {
    switch type {
    case "zip", "xip", "iso", "dmg":
      "doc.zipper"
    default:
      isDirectory ? "folder" : "doc"
    }
  }
}
