//
// FileServer.swift
// Created by Arpit Williams on 15/05/24.
// Copyright (c) 2026 StarKnights Technologies

import Foundation
import Leaf
import Vapor

public final class FileServer: FileServerProtocol, @unchecked Sendable {

  private let app: Application
  private let filesManager: FilesManagerProtocol

  public var port = 80
  public var updateHandler: (@Sendable (URL, HTTPMethod) -> Void)?

  init(filesManager: FilesManagerProtocol) {
    // swiftlint:disable:next force_try
    app = try! Application(.detect())
    self.filesManager = filesManager
    configure(app)
  }

  private func configure(_ app: Application) {
    app.http.server.configuration.port = port
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
      try app.register(
        collection: FileController(
          filesManager: filesManager,
          updateHandler: updateHandler
        )
      )
      await app.server.shutdown()
      do {
        try await app.execute()
      } catch {
        // Bump port & restart server on error
        await bumpServerPort()
      }
    }
  }

  private func bumpServerPort() async {
    do {
      // Limit server restart tries till port 100
      guard port <= 100 else { return }
      port += 1
      app.http.server.configuration.port = port
      try await app.execute()
    } catch {
      await bumpServerPort()
    }
  }
}
