//
// FilesManager.swift
// Created by Arpit Williams on 22/05/24.
// Copyright (c) 2024 StarKnights Technologies

import Foundation
import UniformTypeIdentifiers

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
    let folderPath = try documentsDirectory().appendingPathComponent(folder)
    guard folderPath.isDirectory == false else {
      throw FileError.folderAlreadyExists
    }
    try fileManager.createDirectory(at: folderPath, withIntermediateDirectories: false)
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

  public func copy(from source: URL, to target: URL) throws {
    guard fileManager.fileExists(atPath: target.relativePath) == false else {
      throw FileError.fileAlreadyExists
    }
    try fileManager.copyItem(at: source, to: target)
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

  public static let supportedTypes: [UTType] = [
    .aiff,
    .aliasFile,
    .appleArchive,
    .appleProtectedMPEG4Audio,
    .appleProtectedMPEG4Video,
    .appleScript,
    .application,
    .applicationBundle,
    .applicationExtension,
    .arReferenceObject,
    .archive,
    .assemblyLanguageSource,
    .audio,
    .audiovisualContent,
    .avi,
    .binaryPropertyList,
    .bmp,
    .bookmark,
    .bundle,
    .bz2,
    .cHeader,
    .cPlusPlusHeader,
    .cPlusPlusSource,
    .cSource,
    .calendarEvent,
    .commaSeparatedText,
    .compositeContent,
    .contact,
    .content,
    .data,
    .database,
    .delimitedText,
    .diskImage,
    .emailMessage,
    .epub,
    .exe,
    .executable,
    .fileURL,
    .flatRTFD,
    .font,
    .framework,
    .gif,
    .gzip,
    .heic,
    .heif,
    .html,
    .icns,
    .ico,
    .image,
    .internetLocation,
    .internetShortcut,
    .item,
    .javaScript,
    .jpeg,
    .json,
    .livePhoto,
    .log,
    .m3uPlaylist,
    .makefile,
    .message,
    .midi,
    .mountPoint,
    .movie,
    .mp3,
    .mpeg,
    .mpeg2TransportStream,
    .mpeg2Video,
    .mpeg4Audio,
    .mpeg4Movie,
    .objectiveCPlusPlusSource,
    .objectiveCSource,
    .osaScript,
    .osaScriptBundle,
    .package,
    .pdf,
    .perlScript,
    .phpScript,
    .pkcs12,
    .plainText,
    .playlist,
    .pluginBundle,
    .png,
    .presentation,
    .propertyList,
    .pythonScript,
    .quickLookGenerator,
    .quickTimeMovie,
    .rawImage,
    .realityFile,
    .resolvable,
    .rtf,
    .rtfd,
    .rubyScript,
    .sceneKitScene,
    .script,
    .shellScript,
    .sourceCode,
    .spotlightImporter,
    .spreadsheet,
    .svg,
    .swiftSource,
    .symbolicLink,
    .systemPreferencesPane,
    .tabSeparatedText,
    .text,
    .threeDContent,
    .tiff,
    .toDoItem,
    .unixExecutable,
    .url,
    .urlBookmarkData,
    .usd,
    .usdz,
    .utf16ExternalPlainText,
    .utf16PlainText,
    .utf8PlainText,
    .utf8TabSeparatedText,
    .vCard,
    .video,
    .volume,
    .wav,
    .webArchive,
    .webP,
    .x509Certificate,
    .xml,
    .xmlPropertyList,
    .xpcService,
    .yaml,
    .zip
  ]
}
