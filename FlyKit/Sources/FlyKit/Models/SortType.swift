//
// SortType.swift
// Created by Arpit Williams on 30/05/24.
// Copyright (c) 2024 StarKnights Technologies

enum SortType: CaseIterable {

  case date, name, size, type

  var name: String {
    switch self {
    case .date:
      "Date"
    case .name:
      "Name"
    case .size:
      "Size"
    case .type:
      "Type"
    }
  }
}
