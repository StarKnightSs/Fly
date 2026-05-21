//
// AppConfigManagerProtocol.swift
// Created by Arpit Williams on 26/06/24.
// Copyright (c) 2026 StarKnights Technologies

import Foundation

public protocol AppConfigManagerProtocol: Sendable {
  func getConfig() async throws -> AppConfig
}
