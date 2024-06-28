//
// AdMobView.swift
// Created by Arpit Williams on 19/03/24.
// Copyright (c) 2024 StarKnights Technologies

import SwiftUI

public struct AdMobView: UIViewControllerRepresentable, Equatable {
  public let viewController = UIViewController()
  public init() {}
  public func makeUIViewController(context: Context) -> some UIViewController { viewController }
  public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
