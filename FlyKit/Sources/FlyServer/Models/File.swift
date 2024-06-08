//
// File.swift
// Created by Arpit Williams on 22/05/24.
// Copyright (c) 2024 StarKnights Technologies

import Foundation

public struct File: Equatable, Identifiable {
  public let id: UUID
  public let url: URL
  public let name: String
  public let size: String
  public let type: String
  public let fileSize: Int
  public let isDirectory: Bool
  public let itemCount: String
  public let createdAt: String
  public let creationDate: Date
}

// swiftlint:disable force_unwrapping
public extension File {
  static let mockFile = File(
    id: UUID(),
    url: URL(string: "test.com")!,
    name: "File",
    size: "10 MB",
    type: "TXT",
    fileSize: 1024,
    isDirectory: false,
    itemCount: "0",
    createdAt: "01/01/24",
    creationDate: .now
  )

  static let mockFolder = File(
    id: UUID(),
    url: URL(string: "test.com")!,
    name: "Folder",
    size: "0 KB",
    type: "TXT",
    fileSize: 1024,
    isDirectory: true,
    itemCount: "12 items",
    createdAt: "01/01/24",
    creationDate: .now
  )
}

// swiftlint:enable force_unwrapping
