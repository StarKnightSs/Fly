//
// Progress.swift
// Created by Arpit Williams on 08/06/24.
// Copyright (c) 2024 StarKnights Technologies

import Foundation

public struct Progress: Equatable {
  public let value: Double
  public let speed: Double
  public let time: Double
}

public extension Progress {

  static let zero = Progress(
    value: 0, speed: 0, time: 0
  )

  static let mock = Progress(
    value: 0.48, speed: 8.48, time: 4.48
  )
}
