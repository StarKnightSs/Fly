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
}
