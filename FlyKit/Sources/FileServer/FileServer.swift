//
// FileServer.swift
// Created by Arpit Williams on 16/05/24.
// Copyright (c) 2024 StarKnights Technologies

import Foundation
import Leaf
import Vapor

public final class FileServer: ObservableObject {

  private let port: Int
  private var app: Application
  @Published public var fileURLs: [URL] = []

  public init(port: Int) throws {
    self.port = port
    app = try Application(.detect())
    configure(app)
  }

  private func configure(_ app: Application) {
    app.http.server.configuration.hostname = "0.0.0.0"
    app.http.server.configuration.port = port
    app.middleware.use(FileMiddleware(publicDirectory: Bundle.module.resourcePath ?? ""))

    app.views.use(.leaf)
    app.leaf.cache.isEnabled = app.environment.isRelease
    app.leaf.configuration.rootDirectory = Bundle.module.resourcePath ?? ""
    app.routes.defaultMaxBodySize = "100GB"
  }

  public func start() {
    Task(priority: .background) {
      try app.register(
        collection: FileController(
          filesChanged: { Task { [weak self] in
            await self?.loadFiles()
          }}
        )
      )
      try await app.startup()
    }
  }

  @MainActor
  public func loadFiles() {
    do {
      let documentsDirectory = try URL.documentsDirectory()
      let fileUrls = try documentsDirectory.visibleContents()
      self.fileURLs = fileUrls
    } catch {
      print(error)
    }
  }

  public func deleteFile(at indexes: [Int]) {
    let urls = indexes.map { fileURLs[$0] }
    fileURLs = fileURLs.filter {
      urls.contains($0) == false
    }
    for url in urls {
      try? FileManager.default.removeItem(at: url)
    }
    Task {
      await loadFiles()
    }
  }
}

extension Notification.Name {
  static let serverFilesChanged = Notification.Name("serverFilesChanged")
}
