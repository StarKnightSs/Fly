//
// FilesManagerMock.swift
// Created by Arpit Williams on 10/06/24.
// Copyright (c) 2024 StarKnights Technologies

import Foundation
import UniformTypeIdentifiers

public extension FilesManager {
  struct Mock: FilesManagerProtocol {
    // swiftlint:disable:next force_unwrapping
    let url = URL(string: "www.test.com")!
    public var supportedTypes: [UTType] = []
    public init(fileManager: FileManager = FileManager()) {}
    public func documentsDirectory() throws -> URL { url }
    public func remove(at url: URL) throws {}
    public func create(folder: String) throws -> URL { url }
    public func copy(from source: URL, to target: URL) throws {}
    public func rename(at source: URL, to filename: String) throws -> URL { url }
    public func fileExists(at url: URL) -> Bool { false }
    public func file(for url: URL) -> File? { nil }
    public func fileCount(for url: URL) throws -> Int? { 0 }
    public func filePath(for fileName: String) throws -> URL { url }
    public func setCurrentDirectory(to url: URL) {}
    public func filesAtCurrentDirectory() throws -> [File] { [] }
  }
}
