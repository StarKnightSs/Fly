//
// FileServer.swift
// Created by Arpit Williams on 16/05/24.
// Copyright (c) 2024 StarKnights Technologies

import Foundation
import Leaf
import Vapor

public final class FileServer {

  private let app: Application
  public let filesManager: FilesManager

  public init(filesManager: FilesManager) {
    // swiftlint:disable:next force_try
    app = try! Application(.detect())
    self.filesManager = filesManager
    configure(app)
  }

  private func configure(_ app: Application) {
    app.http.server.configuration.port = 80
    app.http.server.configuration.hostname = "0.0.0.0"
    app.routes.defaultMaxBodySize = "100GB"
    app.views.use(.leaf)
    app.leaf.cache.isEnabled = true

    let resourcePath = Bundle.module.resourcePath ?? ""
    app.leaf.configuration.rootDirectory = resourcePath
    app.middleware.use(FileMiddleware(publicDirectory: resourcePath))
  }

  public func start() {
    Task(priority: .background) {
      try app.register(collection: FileController(
        filesManager: filesManager
      ))
      try await app.startup()
    }
  }
}
