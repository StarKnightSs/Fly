//
// FlyViewModel.swift
// Created by Arpit Williams on 23/05/24.
// Copyright (c) 2024 StarKnights Technologies

import FileServer
import Foundation

public class FlyViewModel: ObservableObject {

  let server: FileServer
  let filesManager: FilesManager
  @Published var files: [File]

  public init(filesManager: FilesManager, files: [File] = []) {
    self.filesManager = filesManager
    self.server = FileServer(filesManager: filesManager)
    self.files = files

    NotificationCenter.default.addObserver(
      forName: .filesUpdated, object: nil, queue: .main
    ) { [weak self] _ in
      self?.loadFiles()
    }
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  func addFolder(_ name: String) {
    do {
      try filesManager.create(folder: name)
      loadFiles()
    } catch {
      print(error)
    }
  }

  public func loadFiles() {
    do {
      let directory = try filesManager.documentsDirectory()
      files = try filesManager.files(at: directory)
    } catch {
      print(error)
    }
  }

  public func deleteFile(at indexes: [Int]) {
    indexes.forEach {
      try? filesManager.remove(at: files[$0].url)
    }
    loadFiles()
  }

  func importFiles(result: Result<[URL], any Error>) {
    switch result {
    case let .success(urls):
      for url in urls {
        if url.startAccessingSecurityScopedResource() {
          do {
            let filePath = try filesManager.filePath(for: url.lastPathComponent)
            try filesManager.copy(from: url, to: filePath)
          } catch {
            print(error)
          }
        }
        url.stopAccessingSecurityScopedResource()
      }
      loadFiles()

    case let .failure(error):
      print(error.localizedDescription)
    }
  }
}
