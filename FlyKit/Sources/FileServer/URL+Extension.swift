//
// URL+Extension.swift
// Created by Arpit Williams on 17/05/24.
// Copyright (c) 2024 StarKnights Technologies

import Foundation

extension URL {
  static func documentsDirectory() throws -> URL {
    try FileManager.default.url(
      for: .documentDirectory,
      in: .userDomainMask,
      appropriateFor: nil,
      create: false
    )
  }

  func visibleContents() throws -> [URL] {
    try FileManager.default.contentsOfDirectory(
      at: self,
      includingPropertiesForKeys: nil,
      options: .skipsHiddenFiles
    )
  }
}
