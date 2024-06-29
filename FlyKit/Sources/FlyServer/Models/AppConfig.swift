//
// AppConfig.swift
// Created by Arpit Williams on 26/06/24.
// Copyright (c) 2024 StarKnights Technologies

import Foundation

public struct AppConfig: Codable, Equatable {
  public let id: UUID
  public let openCount: Int?
  public let fileCount: Int?
  public let askReview: Bool?
  public let enableAdmob: Bool?
}

// MARK: - Create

public extension AppConfig {
  static func create(with id: UUID, fileCount: Int) -> Self {
    AppConfig(
      id: id,
      openCount: nil,
      fileCount: fileCount,
      askReview: nil,
      enableAdmob: nil
    )
  }
}

// MARK: - Mock

public extension AppConfig {
  static let mock = AppConfig(
    id: UUID(),
    openCount: 0,
    fileCount: 0,
    askReview: false,
    enableAdmob: false
  )
}
