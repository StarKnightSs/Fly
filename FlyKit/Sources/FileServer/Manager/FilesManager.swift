//
// FilesManager.swift
// Created by Arpit Williams on 22/05/24.
// Copyright (c) 2024 StarKnights Technologies

import UIKit

public final class FilesManager {

  let fileManager: FileManager

  public init(fileManager: FileManager) {
    self.fileManager = fileManager
  }

  private let filesizeFormmater: ByteCountFormatter = {
    let formatter = ByteCountFormatter()
    formatter.allowedUnits = [.useKB, .useMB, .useGB]
    formatter.countStyle = .file
    return formatter
  }()

  private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
  }()

  public func documentsDirectory() throws -> URL {
    try fileManager.url(
      for: .documentDirectory,
      in: .userDomainMask,
      appropriateFor: nil,
      create: false
    )
  }

  public func create(folder: String) throws {
    try fileManager.createDirectory(
      at: documentsDirectory().appendingPathComponent(folder),
      withIntermediateDirectories: false
    )
  }

  public func filePath(for fileName: String) throws -> URL {
    try documentsDirectory().appendingPathComponent(fileName)
  }

  public func files(at path: URL) throws -> [File] {
    try fileManager.contentsOfDirectory(
      at: path,
      includingPropertiesForKeys: FilesManager.resourceKeys,
      options: .skipsHiddenFiles
    )
    .map {
      let value = try $0.resourceValues(forKeys: Set(FilesManager.resourceKeys))
      return File(
        url: $0,
        name: value.name ?? "Unknown",
        size: filesizeFormmater.string(fromByteCount: Int64(value.fileSize ?? 0)),
        type: value.contentType?.preferredFilenameExtension ?? "",
        isDirectory: value.isDirectory ?? false,
        createdAt: dateFormatter.string(from: value.creationDate ?? Date()),
        modifiedAt: dateFormatter.string(from: value.contentModificationDate ?? Date()),
        lastOpenedAt: dateFormatter.string(from: value.contentAccessDate ?? Date())
      )
    }
  }

  public func remove(at url: URL) throws {
    try fileManager.removeItem(at: url)
  }
}

extension FilesManager {

  static let resourceKeys: [URLResourceKey] = [
    .nameKey,
    .contentTypeKey,
    .isDirectoryKey,
    .fileSizeKey,
    .fileProtectionKey,
    .fileAllocatedSizeKey,
    .creationDateKey,
    .contentAccessDateKey,
    .contentModificationDateKey
  ]
}
