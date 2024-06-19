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
    routes.get("download", ":filename", use: download)
    routes.get("delete", ":filename", use: delete)
    routes.on(.POST, ":filename", ":filesize", body: .stream, use: upload)
  }

  func filesViewHandler(_ req: Request) async throws -> View {
    let files = try filesManager.filesAtCurrentDirectory()
    let filenames = files.map(\.url.lastPathComponent)
    let context = FileContext(filenames: filenames)
    return try await req.view.render("files", context)
  }

  func download(_ req: Request) throws -> Response {
    
    // Get path & size for requested filename
    guard let filename = req.parameters.get("filename"),
          let fileUrl = try? filesManager.filePath(for: filename),
          let fileSize = fileUrl.fileSize
    else { throw Abort(.badRequest) }

    // Create header to send file size
    var headers: HTTPHeaders = [:]
    headers.replaceOrAdd(name: .contentLength, value: fileSize.description)

    // Initiate progress tracking
    Task(priority: .high) { @MainActor in
      AudioManager.shared.play()
      await ProgressManager.shared.initiate(with: Int64(fileSize))
    }

    // Generate streaming response
    let response = Response(status: .ok, headers: headers)
    response.body = .init(
      stream: { stream in
        req.fileio.readFile(at: fileUrl.path) { buffer in

          // Update progress
          Task(priority: .high) { @MainActor in
            await ProgressManager.shared.updateProgress(
              bytes: Int64(buffer.readableBytes)
            )
          }

          // Write buffer to stream
          return stream.write(.buffer(buffer))
        }
        .whenComplete { result in

          // End progress
          Task(priority: .high) { @MainActor in
            AudioManager.shared.stop()
            await ProgressManager.shared.endProgress()
          }

          // End Stream
          switch result {
          case let .failure(error):
            stream.write(.error(error), promise: nil)
          case .success:
            stream.write(.end, promise: nil)
          }
        }
      },
      count: fileSize,
      byteBufferAllocator: req.byteBufferAllocator
    )
    return response
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
    do {
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

      // Setup file handle for file url
      let fileUrl = tempFileUrl
      let fileHandle = try await req.application.fileio.openFile(
        path: fileUrl.relativePath, mode: .write,
        flags: .allowFileCreation(), eventLoop: req.eventLoop
      ).get()
      defer { try? fileHandle.close() }

      // Create promise & future to handle byte buffer stream
      let stream = req.eventLoop.makePromise(of: Void.self)
      let sequential = Sequential(future: req.eventLoop.makeSucceededFuture(()))

      // Initiate progress tracking
      if let totalSize = Int64(filesize) {
        await ProgressManager.shared.initiate(with: totalSize)
      }

      // Collect all streaming bytes
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

      // Await for stream & sequential
      try await stream.futureResult.get()
      try await sequential.future.get()

      // Call update handler
      if let updateHandler {
        updateHandler(fileUrl, .POST)
      }

      // End progress
      AudioManager.shared.stop()
      await ProgressManager.shared.endProgress()

      // Print saved file path
      print("Path \(fileUrl.absoluteString)")

      // Redirect to home
      return req.redirect(to: "/")

    } catch {
      AudioManager.shared.stop()
      await ProgressManager.shared.endProgress()
      throw (error)
    }
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
