//
// ZipManager.swift
// Created by Arpit Williams on 20/06/24.
// Copyright (c) 2024 StarKnights Technologies

import Foundation
import Zip

public final class ZipManager: ZipManagerProtocol {

  private let filesManager: FilesManager

  public init(filesManager: FilesManager) {
    self.filesManager = filesManager
  }

  /// Archives the given files in temp directory
  public func zip(files: [URL], progress: ((Double) -> Void)?) throws -> URL {
    do {
      let archiveUrl = try filesManager.temporaryDirectory().appendingPathComponent("archive.zip")
      try Zip.zipFiles(
        paths: files, zipFilePath: archiveUrl,
        password: nil, compression: .BestSpeed
      ) {
        progress?($0)
      }
      return archiveUrl
    } catch {
      throw error
    }
  }
}
