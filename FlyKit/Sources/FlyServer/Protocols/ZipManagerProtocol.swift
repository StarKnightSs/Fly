//
// ZipManagerProtocol.swift
// Created by Arpit Williams on 20/06/24.
// Copyright (c) 2026 StarKnights Technologies

import Foundation

public protocol ZipManagerProtocol: Sendable {
  func zip(files: [URL]) throws
}
