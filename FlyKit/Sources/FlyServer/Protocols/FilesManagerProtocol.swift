//
// FilesManagerProtocol.swift
// Created by Arpit Williams on 10/06/24.
// Copyright (c) 2024 StarKnights Technologies

import Foundation

public protocol FilesManagerProtocol {
  init(fileManager: FileManager)
  func remove(at url: URL) throws
  func create(folder: String) throws -> URL
  func copy(from source: URL, to target: URL) throws
  func rename(at source: URL, to filename: String) throws -> URL
  func fileExists(at url: URL) -> Bool
  func file(for url: URL) -> File?
  func fileCount(for url: URL) throws -> Int?
  func files(at directory: URL) throws -> [File]
  func filePath(for fileName: String) throws -> URL
}
