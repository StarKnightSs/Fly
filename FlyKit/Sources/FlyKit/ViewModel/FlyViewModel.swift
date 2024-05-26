//
// FlyViewModel.swift
// Created by Arpit Williams on 23/05/24.
// Copyright (c) 2024 StarKnights Technologies

import FileServer
import Foundation
import SwiftUI

public class FlyViewModel: ObservableObject {

  let server: FileServer
  let filesManager: FilesManager

  @Published var files: [File]
  @Published var folderName = ""
  @Published var previewFile: URL?
  @Published var showFolderAlert = false
  @Published var showFilesPicker = false
  @Published var selectedFiles = Set<UUID>()
  @Published var editMode = EditMode.inactive

  public init(filesManager: FilesManager, files: [File] = []) {
    self.files = files
    self.filesManager = filesManager
    self.server = FileServer(filesManager: filesManager)

    self.server.updateHandler = { [weak self] url, type in
      switch type {
      case .POST:
        self?.addFile(at: url)
      case .DELETE:
        self?.removeFile(at: url)
      default:
        break
      }
    }
  }

  deinit {
    server.updateHandler = nil
  }

  func loadFiles() {
    Task { @MainActor in
      do {
        let url = try filesManager.documentsDirectory()
        files = try filesManager.files(at: url)
      } catch {
        print(error)
      }
    }
  }

  func addFile(at url: URL) {
    Task { @MainActor in
      if let file = filesManager.file(for: url) {
        files.append(file)
      }
    }
  }

  func addFolder(_ name: String) {
    do {
      guard name.isEmpty == false else { return }
      let folderPath = try filesManager.create(folder: name)
      addFile(at: folderPath)
    } catch {
      print(error)
    }
  }

  func removeFile(at url: URL) {
    Task { @MainActor in
      files.removeAll { $0.url == url }
    }
  }

  func deleteFile(at indexes: [Int]) {
    indexes.forEach {
      try? filesManager.remove(at: files[$0].url)
    }
    files = files.enumerated()
      .filter { indexes.contains($0.offset) == false }
      .map(\.element)
  }

  func importFiles(result: Result<[URL], any Error>) {
    switch result {
    case let .success(urls):
      for url in urls {
        if url.startAccessingSecurityScopedResource() {
          do {
            let filePath = try filesManager.filePath(for: url.lastPathComponent)
            try filesManager.copy(from: url, to: filePath)
            addFile(at: filePath)
          } catch {
            print(error)
          }
        }
        url.stopAccessingSecurityScopedResource()
      }

    case let .failure(error):
      print(error.localizedDescription)
    }
  }
}
