//
// AppConfigManagerMock.swift
// Created by Arpit Williams on 26/06/24.
// Copyright (c) 2024 StarKnights Technologies

import Foundation

public extension AppConfigManager {
  struct Mock: AppConfigManagerProtocol {
    public init() {}
    public func getConfig() async throws -> AppConfig { AppConfig.mock }
  }
}
