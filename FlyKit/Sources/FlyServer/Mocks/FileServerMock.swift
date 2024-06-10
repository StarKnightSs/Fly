//
// FileServerMock.swift
// Created by Arpit Williams on 10/06/24.
// Copyright (c) 2024 StarKnights Technologies

import Foundation

public extension FileServer {
  struct Mock: FileServerProtocol {
    public init() {}
    public func start() {}
    public var updateHandler: ((URL, HTTPMethod) -> Void)?
  }
}
