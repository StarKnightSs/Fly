//
// ProgressManager.swift
// Created by Arpit Williams on 07/06/24.
// Copyright (c) 2024 StarKnights Technologies

import Foundation

@MainActor
public final class ProgressManager {

  public static let shared = ProgressManager()
  public var trackProgress: ((
    _ progress: Double,
    _ speed: Double,
    _ time: Double
  ) -> Void)?

  private var progress = Progress()
  private var startTime = Date.now
  private var lastTime = Date.now
  private var lastProgress = 0.0
  private var lastMegaBytes = 0.0
  private var transferredBytes = Int64(0)

  var elapsedTime: Double {
    Date.now.timeIntervalSince(startTime)
  }

  var seconds: Double {
    Date.now.timeIntervalSince(lastTime)
  }

  var currentProgress: Double {
    round(progress.fractionCompleted * 100)
  }

  var speed: Double {
    guard seconds > 0, transferredBytes > 0 else { return 0.0 }
    let megaBytes = Double(transferredBytes) / 1024 / 1024
    let mbps = (megaBytes - lastMegaBytes) / seconds
    let speed = round(mbps * 100) / 100.0
    lastMegaBytes = megaBytes
    lastTime = Date.now
    lastProgress = currentProgress
    return speed
  }

  private init() {}

  func initiate(with total: Int64) {
    reset()
    progress = Progress(totalUnitCount: total)
    sendProgress()
  }

  func updateProgress(bytes: Int64) {
    transferredBytes += bytes
    progress.completedUnitCount = transferredBytes
    if currentProgress - lastProgress > 0 {
      sendProgress()
    }
  }

  func endProgress() {
    progress.cancel()
    sendProgress()
    reset()
  }

  func sendProgress() {
    trackProgress?(currentProgress, speed, elapsedTime)
  }

  func reset() {
    startTime = Date.now
    lastTime = Date.now
    lastProgress = 0
    lastMegaBytes = 0
    transferredBytes = 0
  }
}
