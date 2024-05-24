//
// ViewExtension.swift
// Created by Arpit Williams on 24/05/24.
// Copyright (c) 2024 StarKnights Technologies

import SwiftUI

public extension View {

  func modify<Content>(@ViewBuilder _ transform: (Self) -> Content) -> Content {
    transform(self)
  }
}
