//
// Utilities.swift
// Created by Arpit Williams on 06/06/24.
// Copyright (c) 2024 StarKnights Technologies

import UIKit

func share(_ items: [Any]) {
  let activity = UIActivityViewController(
    activityItems: items,
    applicationActivities: nil
  )
  let connectedScenes = UIApplication.shared.connectedScenes
    .filter { $0.activationState == .foregroundActive }
    .compactMap { $0 as? UIWindowScene }
  let window = connectedScenes.first?.windows.first { $0.isKeyWindow }
  window?.rootViewController?.present(activity, animated: true)
}
