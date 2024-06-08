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

func format(_ seconds: Double) -> String {
  var suffix = ""
  var seconds = seconds
  switch seconds {
  case 0 ..< 60:
    suffix = "sec"
  case 60 ..< 3600:
    suffix = "min"
    seconds /= 60
  default:
    suffix = "hrs"
    seconds /= 3600
  }
  let time = seconds.formatted(.number.precision(.fractionLength(2)))
  return String(format: "%@ %@", time, suffix)
}
