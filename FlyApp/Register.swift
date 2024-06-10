//
// Register.swift
// Created by Arpit Williams on 10/06/24.
// Copyright (c) 2024 StarKnights Technologies

import FlyServer
import Resolver

extension Resolver: ResolverRegistering {
  public static func registerAllServices() {
    Resolver.defaultScope = .shared
    registerFlyServer()
    registerFlyKit()
  }
}
