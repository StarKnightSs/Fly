//
// Register.swift
// Created by Arpit Williams on 10/06/24.
// Copyright (c) 2024 StarKnights Technologies

import Foundation
import Resolver

public extension Resolver {
  static func registerFlyServer() {
    register { FileManager.default }
    register { FilesManager(fileManager: resolve()) }
      .implements(FilesManagerProtocol.self)
    register { FileServer(filesManager: resolve()) }
      .implements(FileServerProtocol.self)
  }
}
