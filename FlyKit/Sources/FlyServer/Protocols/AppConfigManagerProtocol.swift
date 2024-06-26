//
// AppConfigManagerProtocol.swift
// Created by Arpit Williams on 26/06/24.
// Copyright (c) 2024 StarKnights Technologies

import Foundation

public protocol AppConfigManagerProtocol {
  func getConfig() async throws -> AppConfig
}
