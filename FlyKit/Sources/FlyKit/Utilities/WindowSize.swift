//
// WindowSize.swift
// Created by Arpit Williams on 01/07/24.
// Copyright (c) 2024 StarKnights Technologies

import SwiftUI

private struct WindowSize: EnvironmentKey {
  static let defaultValue: CGSize = .zero
}

public extension EnvironmentValues {
  var windowSize: CGSize {
    get { self[WindowSize.self] }
    set { self[WindowSize.self] = newValue }
  }
}
