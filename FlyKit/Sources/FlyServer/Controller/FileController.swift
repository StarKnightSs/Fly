//
// FileController.swift
// Created by Arpit Williams on 18/05/24.
// Copyright (c) 2024 StarKnights Technologies

import NIOCore
import Vapor

struct FileController: RouteCollection {

  private let filesManager: FilesManager
  private var updateHandler: ((URL, HTTPMethod) -> Void)?

  init(
    filesManager: FilesManager,
    updateHandler: ((URL, HTTPMethod) -> Void)?
  ) {
    self.filesManager = filesManager
    self.updateHandler = updateHandler
  }

  func boot(routes: RoutesBuilder) throws {
    routes.get(use: filesViewHandler)
    routes.get(":filename", use: download)
    routes.get("delete", ":filename", use: delete)
    routes.on(.POST, ":filename", ":filesize", body: .stream, use: upload)
  }

  func filesViewHandler(_ req: Request) async throws -> View {
    let directory = try filesManager.documentsDirectory()
    let files = try filesManager.files(at: directory)
    let filenames = files.map(\.url.lastPathComponent)
    let context = FileContext(filenames: filenames)
    return try await req.view.render("files", context)
  }

  func download(_ req: Request) throws -> Response {
    guard let filename = req.parameters.get("filename") else {
      throw Abort(.badRequest)
    }
    let fileUrl = try filesManager.filePath(for: filename)
    return req.fileio.streamFile(at: fileUrl.path)
  }

  func delete(_ req: Request) throws -> Response {
    guard let filename = req.parameters.get("filename") else {
      throw Abort(.badRequest)
    }
    let url = try filesManager.filePath(for: filename)
    try filesManager.remove(at: url)
    updateHandler?(url, .DELETE)
    return req.redirect(to: "/")
  }

  func upload(_ req: Request) async throws -> Response {

    // Get file name & size from request
    guard var filename = req.parameters.get("filename"),
          let filesize = req.parameters.get("filesize")
    else { throw Abort(.badRequest) }

    // Start audio playback for background processing
    AudioManager.shared.play()

    // Update filename & fileUrl if file already exists
    var tempFileUrl = try filesManager.filePath(for: filename)
    if filesManager.fileExists(at: tempFileUrl) {
      filename = "(Copy-\(Int.random(in: 1 ..< 50))) ".appending(filename)
      tempFileUrl = try filesManager.filePath(for: filename)
    }

    // Setup handle for file url
    let fileUrl = tempFileUrl
    let fileHandle = try await req.application.fileio.openFile(
      path: fileUrl.relativePath, mode: .write,
      flags: .allowFileCreation(), eventLoop: req.eventLoop
    ).get()
    defer { try? fileHandle.close() }

    let stream = req.eventLoop.makePromise(of: Void.self)
    let sequential = Sequential(future: req.eventLoop.makeSucceededFuture(()))

    // Initiate progress tracking
    if let totalSize = Int64(filesize) {
      await ProgressManager.shared.initiate(with: totalSize)
    }

    req.body.drain {
      switch $0 {
      case let .buffer(buffer):
        sequential.future = sequential.future.flatMap {
          req.application.fileio.write(
            fileHandle: fileHandle,
            buffer: buffer,
            eventLoop: req.eventLoop
          )
        }

        // Update progress
        Task(priority: .high) {
          await ProgressManager.shared.updateProgress(
            bytes: Int64(buffer.readableBytes)
          )
        }

      case let .error(error):
        try? FileManager.default.removeItem(at: fileUrl)
        stream.fail(error)

      case .end:
        stream.succeed(())
      }
      return req.eventLoop.makeSucceededVoidFuture()
    }

    try await stream.futureResult.get()
    try await sequential.future.get()
    AudioManager.shared.stop()
    updateHandler?(fileUrl, .POST)

    // End progress
    await ProgressManager.shared.endProgress()

    print("Path \(fileUrl.absoluteString)")

    return req.redirect(to: "/")
  }
}

struct FileContext: Encodable {
  var filenames: [String]
}

final class Sequential {
  var future: EventLoopFuture<Void>
  init(future: EventLoopFuture<Void>) {
    self.future = future
  }
}
