//
// Utilities.swift
// Created by Arpit Williams on 06/06/24.
// Copyright (c) 2024 StarKnights Technologies

import StoreKit
import SwiftUI
import UIKit

func serverUrl(for port: Int) -> URL {
  let portSuffix = port != 80 ? ":\(port)" : ""
  return URL(string: "http://\(ProcessInfo().hostName)\(portSuffix)") ?? URL.mock
}

func share(_ items: [Any]) {
  let activity = UIActivityViewController(
    activityItems: items,
    applicationActivities: nil
  )
  if let scene = UIApplication.shared.connectedScenes
    .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
    let window = scene.windows.first(where: { $0.isKeyWindow }) {
    window.rootViewController?.present(activity, animated: true)
  }
}

func requestReview() {
  Task { @MainActor in
    if let scene = UIApplication.shared.connectedScenes
      .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
      SKStoreReviewController.requestReview(in: scene)
    }
  }
}

func format(_ seconds: Double) -> String {
  var suffix = ""
  var seconds = seconds
  switch seconds {
  case 0 ..< 60:
    suffix = seconds > 1 ? "secs" : "sec"
  case 60 ..< 3600:
    seconds /= 60
    suffix = seconds > 1 ? "mins" : "min"
  default:
    seconds /= 3600
    suffix = seconds > 1 ? "hrs" : "hr"
  }
  let time = seconds.formatted(.number.precision(.fractionLength(2)))
  return String(format: "%@ %@", time, suffix)
}

func getLinearGradient(
  _ colors: [Color],
  startPoint: UnitPoint = .top,
  endPoint: UnitPoint = .bottom
) -> some View {
  LinearGradient(
    gradient: Gradient(colors: colors),
    startPoint: startPoint, endPoint: endPoint
  )
}
