//
// Register.swift
// Created by Arpit Williams on 10/06/24.
// Copyright (c) 2024 StarKnights Technologies

import Foundation
import Resolver

public extension Resolver {
  static func registerFlyKit() {
    register {
      Dependencies(
        server: resolve(),
        filesManager: resolve(),
        zipManager: resolve(),
        appConfigManager: resolve()
      )
    }.implements(DependenciesProtocol.self)
  }
}
