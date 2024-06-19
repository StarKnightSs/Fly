//
// URLExtension.swift
// Created by Arpit Williams on 23/05/24.
// Copyright (c) 2024 StarKnights Technologies

import Foundation

public extension URL {

  var isDirectory: Bool {
    (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
  }

  var fileSize: Int? {
    (try? resourceValues(forKeys: [.fileSizeKey]))?.fileSize
  }

  func excludeFromBackup() {
    var url = self
    var values = URLResourceValues()
    values.isExcludedFromBackup = true
    try? url.setResourceValues(values)
  }
}
