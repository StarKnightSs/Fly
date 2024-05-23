//
// File.swift
// Created by Arpit Williams on 22/05/24.
// Copyright (c) 2024 StarKnights Technologies

import Foundation

public struct File {
  public let url: URL
  public let name: String
  public let size: String
  public let type: String
  public let isDirectory: Bool
  public let createdAt: String
  public let modifiedAt: String
  public let lastOpenedAt: String
}
