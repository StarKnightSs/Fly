//
// FlyViewModel.swift
// Created by Arpit Williams on 23/05/24.
// Copyright (c) 2024 StarKnights Technologies

import FileServer
import Foundation

public class FlyViewModel: ObservableObject {

  let server: FileServer
  let filesManager: FilesManager

  @Published var files: [File] = []

  public init(filesManager: FilesManager) {
    self.filesManager = filesManager
    self.server = FileServer(filesManager: filesManager)

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
    try? filesManager.create(folder: name)
    loadFiles()
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
}
