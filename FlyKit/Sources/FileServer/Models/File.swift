//
// File.swift
// Created by Arpit Williams on 22/05/24.
// Copyright (c) 2024 StarKnights Technologies

import Foundation

public struct File: Identifiable {
  public let id: UUID
  public let url: URL
  public let name: String
  public let size: String
  public let type: String
  public let isDirectory: Bool
  public let itemCount: String
  public let createdAt: String
}

// swiftlint:disable force_unwrapping
public extension File {
  static let mockFile = File(
    id: UUID(),
    url: URL(string: "test.com")!,
    name: "File",
    size: "10 MB",
    type: "TXT",
    isDirectory: false,
    itemCount: "0",
    createdAt: "01/01/24"
  )

  static let mockFolder = File(
    id: UUID(),
    url: URL(string: "test.com")!,
    name: "Folder",
    size: "0 KB",
    type: "TXT",
    isDirectory: true,
    itemCount: "12 items",
    createdAt: "01/01/24"
  )
}

// swiftlint:enable force_unwrapping
