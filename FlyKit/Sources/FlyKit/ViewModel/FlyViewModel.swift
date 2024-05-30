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
  @Published var showPhotosPicker = false
  @Published var selectedFiles = Set<UUID>()
  @Published var editMode = EditMode.inactive

  public init(filesManager: FilesManager, files: [File] = []) {
    self.files = files
    self.filesManager = filesManager
    self.server = FileServer(filesManager: filesManager)
    loadFiles()
    loadServer()
  }

  func loadFiles() {
    Task { @MainActor in
      do {
        let url = try filesManager.documentsDirectory()
        files = try filesManager.files(at: url)
        sortByDate(ascending: false)
      } catch {
        print(error)
      }
    }
  }

  func loadServer() {
    server.updateHandler = { [weak self] url, type in
      switch type {
      case .POST:
        self?.addFile(at: url)
      case .DELETE:
        self?.removeFile(at: url)
      default:
        break
      }
    }
    server.start()
  }

  var allFilesURLs: [URL] {
    files
      .filter { $0.isDirectory == false }
      .map(\.url)
  }

  func selectAllFiles() {
    selectedFiles = selectedFiles.union(files.map(\.id))
  }
}

// MARK: Add Files

extension FlyViewModel {

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
}

// MARK: Remove Files

extension FlyViewModel {

  func removeFile(at url: URL) {
    Task { @MainActor in
      guard let index = files.firstIndex(where: { $0.url == url })
      else { return }
      files.remove(at: index)
    }
  }

  func removeFiles(at indexes: [Int]) {
    indexes.forEach {
      let url = files[$0].url
      try? filesManager.remove(at: url)
      removeFile(at: url)
    }
  }

  func removeSelectedFiles() {
    let indexes = files.enumerated()
      .filter { selectedFiles.contains($0.element.id) }
      .map(\.offset)
    removeFiles(at: indexes)
    selectedFiles.removeAll()
  }
}

// MARK: Sort Files

extension FlyViewModel {

  func sortFiles(by type: SortType, isAscending: Bool) {
    switch type {
    case .date:
      sortByDate(ascending: isAscending)
    case .name:
      sortByName(ascending: isAscending)
    case .size:
      sortBySize(ascending: isAscending)
    case .type:
      sortByType(ascending: isAscending)
    }
  }

  func sortByDate(ascending: Bool) {
    files = files.sorted(by: {
      ascending ?
        $0.creationDate < $1.creationDate :
        $0.creationDate > $1.creationDate
    })
  }

  func sortByName(ascending: Bool) {
    files = files.sorted(by: {
      ascending ?
        $0.name < $1.name :
        $0.name > $1.name
    })
  }

  func sortBySize(ascending: Bool) {
    files = files.sorted(by: {
      ascending ?
        $0.fileSize < $1.fileSize :
        $0.fileSize > $1.fileSize
    })
  }

  func sortByType(ascending: Bool) {
    files = files.sorted(by: {
      ascending ?
        $0.type < $1.type :
        $0.type > $1.type
    })
  }
}

// MARK: Import Files

extension FlyViewModel {

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

  func importPhotos(from urls: [URL]) {
    urls.forEach { addFile(at: $0) }
  }
}
