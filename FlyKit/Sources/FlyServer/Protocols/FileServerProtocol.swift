//
// FileServerProtocol.swift
// Created by Arpit Williams on 10/06/24.
// Copyright (c) 2026 StarKnights Technologies

import Foundation

public protocol FileServerProtocol: Sendable {
  func start()
  var port: Int { get set }
  var updateHandler: (@Sendable (URL, HTTPMethod) -> Void)? { get set }
}
