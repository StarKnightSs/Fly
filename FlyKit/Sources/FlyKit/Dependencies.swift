//
// Dependencies.swift
// Created by Arpit Williams on 10/06/24.
// Copyright (c) 2026 StarKnights Technologies

import Dependencies
import FlyServer
import Foundation
import Resolver

public protocol DependenciesProtocol: Sendable {
  var server: FileServerProtocol { get }
  var filesManager: FilesManagerProtocol { get }
  var zipManager: ZipManagerProtocol { get }
  var appConfigManager: AppConfigManagerProtocol { get }
  var mainQueue: AnySchedulerOf<DispatchQueue> { get }
}

struct Dependencies: DependenciesProtocol {
  var server: any FileServerProtocol
  var filesManager: any FilesManagerProtocol
  var zipManager: any ZipManagerProtocol
  var appConfigManager: any AppConfigManagerProtocol
  var mainQueue: AnySchedulerOf<DispatchQueue> = .main
}

extension Dependencies: DependencyKey {
  static let liveValue: DependenciesProtocol = Resolver.resolve()
  static let testValue: DependenciesProtocol = Dependencies.mock()
  static let previewValue: DependenciesProtocol = Dependencies.mock()
}

extension DependencyValues {
  var dependencies: DependenciesProtocol {
    get { self[Dependencies.self] }
    set { self[Dependencies.self] = newValue }
  }
}

// MARK: - Mock

extension Dependencies {
  static func mock() -> Self {
    .init(
      server: FileServer.Mock(),
      filesManager: FilesManager.Mock(),
      zipManager: ZipManager.Mock(),
      appConfigManager: AppConfigManager.Mock()
    )
  }
}
