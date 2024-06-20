//
// ZipManagerProtocol.swift
// Created by Arpit Williams on 20/06/24.
// Copyright (c) 2024 StarKnights Technologies

import Foundation

public protocol ZipManagerProtocol {
  init(filesManager: FilesManager)
  func zip(files: [URL], progress: ((Double) -> Void)?) throws -> URL
}
