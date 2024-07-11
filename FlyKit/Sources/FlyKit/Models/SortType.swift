//
// SortType.swift
// Created by Arpit Williams on 30/05/24.
// Copyright (c) 2024 StarKnights Technologies

enum SortType: CaseIterable {

  case date, name, size, type

  var name: String {
    switch self {
    case .date: String.date
    case .name: String.name
    case .size: String.size
    case .type: String.type
    }
  }

  static func type(for name: String) -> Self {
    switch name {
    case String.date: return .date
    case String.name: return .name
    case String.size: return .size
    case String.type: return .type
    default: return .date
    }
  }
}
