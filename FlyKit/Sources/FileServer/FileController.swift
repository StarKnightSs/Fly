//
// FileController.swift
// Created by Arpit Williams on 17/05/24.
// Copyright (c) 2024 StarKnights Technologies

import NIOCore
import Vapor

struct FileController: RouteCollection {

  func boot(routes: RoutesBuilder) throws {
    routes.get(use: filesViewHandler)
    routes.get(":filename", use: downloadFileHandler)
    routes.get("delete", ":filename", use: deleteFileHandler)
    routes.on(.POST, ":filename", body: .stream, use: uploadFilePostHandler)
  }

  func filesViewHandler(_ req: Request) async throws -> View {
    let documentsDirectory = try URL.documentsDirectory()
    let fileUrls = try documentsDirectory.visibleContents()
    let filenames = fileUrls.map(\.lastPathComponent)
    let context = FileContext(filenames: filenames)
    return try await req.view.render("files", context)
  }

  func downloadFileHandler(_ req: Request) throws -> Response {
    guard let filename = req.parameters.get("filename") else {
      throw Abort(.badRequest)
    }
    let fileUrl = try URL.documentsDirectory().appendingPathComponent(filename)
    return req.fileio.streamFile(at: fileUrl.path)
  }

  func deleteFileHandler(_ req: Request) throws -> Response {
    guard let filename = req.parameters.get("filename") else {
      throw Abort(.badRequest)
    }
    let fileURL = try URL.documentsDirectory().appendingPathComponent(filename)
    try FileManager.default.removeItem(at: fileURL)
    notifyFileChange()
    return req.redirect(to: "/")
  }

  func uploadFilePostHandler(_ req: Request) async throws -> Response {
    guard let filename = req.parameters.get("filename") else {
      throw Abort(.badRequest)
    }
    let fileUrl = try URL.documentsDirectory().appendingPathComponent(filename)
    try? FileManager.default.removeItem(at: fileUrl)

    return try await req.application.fileio.openFile(
      path: fileUrl.relativePath, mode: .write,
      flags: .allowFileCreation(), eventLoop: req.eventLoop
    ).flatMap { fileHandle in

      let start = Date()
      let promise = req.eventLoop.makePromise(of: Void.self)
      let sequential = Sequential(req.eventLoop.makeSucceededFuture(()))

      req.body.drain {
        switch $0 {
        case let .buffer(buffer):
          sequential.future = sequential.future.flatMap {
            req.application.fileio.write(fileHandle: fileHandle, buffer: buffer, eventLoop: req.eventLoop)
          }

        case let .error(error):
          try? FileManager.default.removeItem(at: fileUrl)
          promise.fail(error)

        case .end:
          promise.succeed(())
        }
        return req.eventLoop.makeSucceededVoidFuture()
      }

      return promise.futureResult
        .flatMap { sequential.future }
        .always { _ in
          notifyFileChange()
          try? fileHandle.close()
        }
        .flatMap { _ in
          print(fileUrl.absoluteString)
          let end = Date()
          let consumedTime = end.timeIntervalSince(start)
          print(consumedTime)
          return req.eventLoop.makeSucceededFuture(req.redirect(to: "/"))
        }
    }
    .get()
  }

  func notifyFileChange() {
    DispatchQueue.main.async {
      NotificationCenter.default.post(name: .serverFilesChanged, object: nil)
    }
  }
}

struct FileContext: Encodable {
  var filenames: [String]
}

class Sequential {
  var future: EventLoopFuture<Void>
  init(_ future: EventLoopFuture<Void>) {
    self.future = future
  }
}
