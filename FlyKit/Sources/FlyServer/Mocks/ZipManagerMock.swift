//
// ZipManagerMock.swift
// Created by Arpit Williams on 20/06/24.
// Copyright (c) 2024 StarKnights Technologies

import Foundation

public extension ZipManager {
  struct Mock: ZipManagerProtocol {
    public init() {}
    public func zip(files: [URL]) throws {}
  }
}
