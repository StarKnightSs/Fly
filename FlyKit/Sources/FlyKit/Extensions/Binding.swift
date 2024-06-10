//
// Binding.swift
// Created by Arpit Williams on 30/05/24.
// Copyright (c) 2024 StarKnights Technologies

import SwiftUI

extension Binding {

  func didSet(_ didSet: @escaping ((newValue: Value, oldValue: Value)) -> Void) -> Binding<Value> {
    .init(
      get: { self.wrappedValue },
      set: { newValue in
        let oldValue = self.wrappedValue
        self.wrappedValue = newValue
        didSet((newValue, oldValue))
      }
    )
  }

  func willSet(_ willSet: @escaping ((newValue: Value, oldValue: Value)) -> Void) -> Binding<Value> {
    .init(
      get: { self.wrappedValue },
      set: { newValue in
        willSet((newValue, self.wrappedValue))
        self.wrappedValue = newValue
      }
    )
  }

  func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
    .init(
      get: { self.wrappedValue },
      set: { newValue in
        self.wrappedValue = newValue
        handler(newValue)
      }
    )
  }
}
