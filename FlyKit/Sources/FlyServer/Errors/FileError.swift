//
// FileError.swift
// Created by Arpit Williams on 23/05/24.
// Copyright (c) 2024 StarKnights Technologies

import Foundation

public enum FileError: Error {
  case filePathInvalid
  case fileAlreadyExists
  case fileDoesNotExists
  case folderAlreadyExists
  case fileLoadingError
  case fileTypeNotSupported
  case currentDirectoryNil
  case currentDirectoryOverwrite

  public var description: String {
    switch self {
    case .filePathInvalid:
      "File path is invlaid"
    case .fileAlreadyExists:
      "File already exists"
    case .fileDoesNotExists:
      "File does not exists"
    case .folderAlreadyExists:
      "Folder already exitsts"
    case .fileLoadingError:
      "Error loading file"
    case .fileTypeNotSupported:
      "This file type is not supported"
    case .currentDirectoryNil:
      "Current directory is nil"
    case .currentDirectoryOverwrite:
      "Cannot overwrite current directory"
    }
  }
}
