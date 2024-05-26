//
// Platform.swift
// Created by Arpit Williams on 26/05/24.
// Copyright (c) 2024 StarKnights Technologies

import UIKit

var iOS15: Bool {
  guard #available(iOS 15, *) else { return false }
  return true
}

var iOS16: Bool {
  guard #available(iOS 16, *) else { return false }
  return true
}

var iOS17: Bool {
  guard #available(iOS 17, *) else { return false }
  return true
}
