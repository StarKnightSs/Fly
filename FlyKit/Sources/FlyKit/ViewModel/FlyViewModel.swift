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
  @Published var fileRename = ""
  @Published var previewFile: URL?
  @Published var showFolderAlert = false
  @Published var showRenameAlert = false
  @Published var showFilesPicker = false
  @Published var showPhotosPicker = false
  @Published var showUploadView = false
  @Published var selectedFiles = Set<UUID>()
  @Published var editMode = EditMode.inactive

  @AppStorage("sortName")
  var sortName = SortType.date.name

  @AppStorage("sortAscending")
  var sortAscending = false

  var sortType: SortType {
    SortType.type(for: sortName)
  }

  var selectedFile: File?

  var allFilesURLs: [URL] {
    files
      .filter { $0.isDirectory == false }
      .map(\.url)
  }

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
        sortFiles()
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
}

// MARK: Select Files

extension FlyViewModel {

  func selectAllFiles() {
    selectedFiles = selectedFiles
      .union(files.map(\.id))
  }

  func deSelectAllFiles() {
    selectedFiles.removeAll()
  }
}

// MARK: Add Files

extension FlyViewModel {

  func addFile(at url: URL) {
    Task { @MainActor in
      if let file = filesManager.file(for: url) {
        files.append(file)
        sortFiles()
      }
    }
  }

  func addFolder(_ name: String) {
    do {
      guard name.isEmpty == false else { return }
      let folderPath = try filesManager.create(folder: name)
      addFile(at: folderPath)
      sortFiles()
    } catch {
      print(error)
    }
  }
}

// MARK: Remove / Rename Files

extension FlyViewModel {

  func removeFile(at url: URL) {
    Task { @MainActor in
      guard let index = files.firstIndex(where: { $0.url == url })
      else { return }
      files.remove(at: index)
      try? filesManager.remove(at: url)
    }
  }

  func removeSelectedFiles() {
    files.enumerated()
      .filter { selectedFiles.contains($0.element.id) }
      .map(\.offset)
      .forEach {
        let url = files[$0].url
        removeFile(at: url)
      }
    deSelectAllFiles()
  }

  func renameFile(at url: URL, to filename: String) {
    Task { @MainActor in
      guard let index = files.firstIndex(where: { $0.url == url }),
            let url = try? filesManager.rename(at: files[index].url, to: filename),
            let file = filesManager.file(for: url)
      else { return }
      files[index] = file
      sortFiles()
    }
  }
}

// MARK: Sort Files

extension FlyViewModel {

  func sortFiles() {
    sortFiles(by: sortType, isAscending: sortAscending)
  }

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

// MARK: Alert Handlers

extension FlyViewModel {

  func folderAlertDone() {
    addFolder(folderName)
    folderAlertDismiss()
  }

  func folderAlertDismiss() {
    folderName = ""
    showFolderAlert = false
  }

  func showRenameAlert(for file: File) {
    selectedFile = file
    fileRename = file.isDirectory ? file.name :
      file.url.deletingPathExtension().lastPathComponent
    showRenameAlert = true
  }

  func renameAlertDone() {
    if let file = selectedFile,
       fileRename.isEmpty == false {
      fileRename = fileRename.trimmingCharacters(in: .whitespacesAndNewlines)
      if file.isDirectory == false {
        fileRename = fileRename + "." + file.type
      }
      renameFile(at: file.url, to: fileRename)
    }
    renameAlertDismiss()
  }

  func renameAlertDismiss() {
    fileRename = ""
    showRenameAlert = false
    selectedFile = nil
  }
}
