//
// ZipManager.swift
// Created by Arpit Williams on 20/06/24.
// Copyright (c) 2024 StarKnights Technologies

import Foundation
import Zip

public final class ZipManager: ZipManagerProtocol {

  /// Archives the given files in temp directory
  public func zip(files: [URL]) throws -> URL {
    do {
      let archiveUrl = FileManager.default.temporaryDirectory
        .appendingPathComponent("Archive.zip")
      try Zip.zipFiles(
        paths: files,
        zipFilePath: archiveUrl,
        password: nil,
        compression: .NoCompression,
        progress: { _ in }
      )
      return archiveUrl
    } catch {
      throw error
    }
  }
}
