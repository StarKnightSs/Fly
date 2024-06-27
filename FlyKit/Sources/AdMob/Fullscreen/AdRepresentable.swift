//
// AdRepresentable.swift
// Created by Arpit Williams on 19/03/24.
// Copyright (c) 2024 StarKnights Technologies

import SwiftUI

// MARK: - Helper to present Interstitial Ad

public struct AdRepresentable: UIViewControllerRepresentable {
  public let viewController = UIViewController()
  public init() {}
  public func makeUIViewController(context: Context) -> some UIViewController { viewController }
  public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
