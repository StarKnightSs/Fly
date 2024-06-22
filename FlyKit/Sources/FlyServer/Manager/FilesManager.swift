//
// FilesManager.swift
// Created by Arpit Williams on 22/05/24.
// Copyright (c) 2024 StarKnights Technologies

import Foundation
import UniformTypeIdentifiers

public final class FilesManager: FilesManagerProtocol {

  private let fileManager: FileManager
  private var currentDirectory: URL?

  public init(fileManager: FileManager) {
    self.fileManager = fileManager
    currentDirectory = try? documentsDirectory()
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

  public func temporaryDirectory() throws -> URL {
    try fileManager.temporaryDirectory
  }

  public func create(folder: String) throws -> URL {
    guard let currentDirectory else { throw FileError.currentDirectoryNil }
    let folderPath = currentDirectory.appendingPathComponent(folder, isDirectory: true)
    try fileManager.createDirectory(at: folderPath, withIntermediateDirectories: false)
    folderPath.excludeFromBackup()
    return folderPath
  }

  public func filePath(for fileName: String) throws -> URL {
    guard let currentDirectory else { throw FileError.currentDirectoryNil }
    return currentDirectory.appendingPathComponent(fileName)
  }

  public func copy(from source: URL, to target: URL) throws {
    guard fileExists(at: target) == false else {
      throw FileError.fileAlreadyExists
    }
    try fileManager.copyItem(at: source, to: target)
    target.excludeFromBackup()
  }

  public func copyFile(from source: URL, shouldMove: Bool) throws {
    guard currentDirectory?.absoluteString.contains(source.absoluteString) == false else {
      throw FileError.currentDirectoryOverwrite
    }
    let fileName = source.lastPathComponent
    guard let filePath = try? filePath(for: fileName) else {
      throw FileError.filePathInvalid
    }
    guard fileExists(at: filePath) == false else {
      throw FileError.fileAlreadyExists
    }
    shouldMove ?
      try fileManager.moveItem(at: source, to: filePath) :
      try fileManager.copyItem(at: source, to: filePath)
    filePath.excludeFromBackup()
  }

  public func rename(at source: URL, to filename: String) throws -> URL {
    guard fileExists(at: source) else { throw FileError.fileDoesNotExists }
    let target = source.deletingLastPathComponent().appendingPathComponent(filename)
    guard fileExists(at: target) == false else { throw FileError.fileAlreadyExists }
    try fileManager.moveItem(at: source, to: target)
    target.excludeFromBackup()
    return target
  }

  public func remove(at url: URL) throws {
    try fileManager.removeItem(at: url)
  }

  public func fileCount(for url: URL) throws -> Int? {
    guard url.isDirectory else { return nil }
    return try fileManager.contentsOfDirectory(
      at: url, includingPropertiesForKeys: nil
    ).count
  }

  public func file(for url: URL) -> File? {
    guard let resource = try? url.resourceValues(forKeys: Set(resourceKeys)) else {
      return nil
    }
    return File(
      id: UUID(),
      url: url,
      name: resource.name ?? "Unknown",
      size: filesizeFormmater.string(fromByteCount: Int64(resource.fileSize ?? 0)),
      type: resource.contentType?.preferredFilenameExtension ?? "",
      fileSize: resource.fileSize ?? 0,
      isDirectory: resource.isDirectory ?? false,
      itemCount: String(format: "%d items", (try? fileCount(for: url)) ?? 0),
      createdAt: dateFormatter.string(from: resource.creationDate ?? Date()),
      creationDate: resource.creationDate ?? .now
    )
  }

  public func fileExists(at url: URL) -> Bool {
    fileManager.fileExists(atPath: url.relativePath)
  }

  public func setCurrentDirectory(to url: URL) {
    currentDirectory = url
  }

  public func filesAtCurrentDirectory() throws -> [File] {
    guard let currentDirectory else { throw FileError.currentDirectoryNil }
    return try fileManager.contentsOfDirectory(
      at: currentDirectory,
      includingPropertiesForKeys: resourceKeys,
      options: .skipsHiddenFiles
    )
    .compactMap {
      file(for: $0.standardizedFileURL)
    }
  }

  public var supportedTypes: [UTType] = [
    .aiff, .aliasFile, .appleArchive, .appleProtectedMPEG4Audio, .appleProtectedMPEG4Video,
    .appleScript, .application, .applicationBundle, .applicationExtension, .arReferenceObject,
    .archive, .audio, .audiovisualContent, .avi, .binaryPropertyList, .bmp, .bookmark,
    .bundle, .bz2, .cHeader, .cPlusPlusHeader, .cPlusPlusSource, .cSource, .calendarEvent,
    .commaSeparatedText, .compositeContent, .contact, .content, .data, .database, .delimitedText,
    .diskImage, .emailMessage, .epub, .exe, .executable, .fileURL, .flatRTFD, .font, .framework,
    .gif, .gzip, .heic, .heif, .html, .icns, .ico, .image, .internetLocation, .internetShortcut,
    .item, .javaScript, .jpeg, .json, .livePhoto, .log, .m3uPlaylist, .makefile, .message, .midi,
    .mountPoint, .movie, .mp3, .mpeg, .mpeg2TransportStream, .mpeg2Video, .mpeg4Audio, .mpeg4Movie,
    .objectiveCPlusPlusSource, .objectiveCSource, .osaScript, .osaScriptBundle, .package, .pdf,
    .perlScript, .phpScript, .pkcs12, .plainText, .playlist, .pluginBundle, .png, .presentation,
    .propertyList, .pythonScript, .quickLookGenerator, .quickTimeMovie, .rawImage, .realityFile,
    .resolvable, .rtf, .rtfd, .rubyScript, .sceneKitScene, .script, .shellScript, .sourceCode,
    .spotlightImporter, .spreadsheet, .svg, .swiftSource, .symbolicLink, .systemPreferencesPane,
    .tabSeparatedText, .text, .threeDContent, .tiff, .toDoItem, .unixExecutable, .url, .urlBookmarkData,
    .usd, .usdz, .utf16ExternalPlainText, .utf16PlainText, .utf8PlainText, .utf8TabSeparatedText, .vCard,
    .video, .volume, .wav, .webArchive, .webP, .x509Certificate, .xml, .xmlPropertyList, .xpcService,
    .yaml, .zip
  ]

  let resourceKeys: [URLResourceKey] = [
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
