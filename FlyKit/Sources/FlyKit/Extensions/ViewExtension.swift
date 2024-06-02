//
// ViewExtension.swift
// Created by Arpit Williams on 24/05/24.
// Copyright (c) 2024 StarKnights Technologies

import SwiftUI

public extension View {

  func modify<Content>(@ViewBuilder _ transform: (Self) -> Content) -> Content {
    transform(self)
  }

  @ViewBuilder
  func `if`(_ condition: Bool, transform: (Self) -> some View) -> some View {
    if condition {
      transform(self)
    } else {
      self
    }
  }

  @ViewBuilder
  func animateReplace() -> some View {
    modify { if #available(iOS 17, *) {
      $0.contentTransition(.symbolEffect(.replace.byLayer.downUp))
    }}
  }

  @ViewBuilder
  func animateBounce(_ value: Bool) -> some View {
    modify { if #available(iOS 17, *) {
      $0.symbolEffect(.bounce.byLayer.up, value: value)
    }}
  }
}
