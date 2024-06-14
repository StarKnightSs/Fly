//
// FilesManagerProtocol.swift
// Created by Arpit Williams on 14/06/24.
// Copyright (c) 2024 StarKnights Technologies

import Foundation
import UniformTypeIdentifiers

public protocol FilesManagerProtocol {
  init(fileManager: FileManager)
  var supportedTypes: [UTType] { get set }
  func documentsDirectory() throws -> URL
  func remove(at url: URL) throws
  func create(folder: String) throws -> URL
  func copy(from source: URL, to target: URL) throws
  func copyFile(from source: URL, shouldMove: Bool) throws
  func rename(at source: URL, to filename: String) throws -> URL
  func fileExists(at url: URL) -> Bool
  func file(for url: URL) -> File?
  func fileCount(for url: URL) throws -> Int?
  func filePath(for fileName: String) throws -> URL
  func setCurrentDirectory(to url: URL)
  func filesAtCurrentDirectory() throws -> [File]
}
