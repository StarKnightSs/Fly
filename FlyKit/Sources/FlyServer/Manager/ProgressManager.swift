//
// ProgressManager.swift
// Created by Arpit Williams on 07/06/24.
// Copyright (c) 2024 StarKnights Technologies

import Foundation

@MainActor
public final class ProgressManager {

  public static let shared = ProgressManager()
  public var trackProgress: ((
    _ progress: Progress,
    _ elapsedTime: Double,
    _ isCompleted: Bool
  ) -> Void)?

  private var progress = Foundation.Progress()
  private var startTime = Date.now
  private var lastTime = Date.now
  private var lastProgress = 0.0
  private var transferredBytes = Int64(0)
  private var lastTransferredMegaBytes = 0.0

  var elapsedTime: Double {
    Date.now.timeIntervalSince(startTime)
  }

  var seconds: Double {
    Date.now.timeIntervalSince(lastTime)
  }

  var currentProgress: Double {
    round(progress.fractionCompleted * 100)
  }

  var speedTime: (speed: Double, time: Double) {
    guard seconds > 0, transferredBytes > 0 else { return (0, 0) }
    let remainingMegaBytes = Double(progress.totalUnitCount - transferredBytes) / 1024 / 1024
    let transferredMegaBytes = Double(transferredBytes) / 1024 / 1024
    let megaBytesPerSecond = (transferredMegaBytes - lastTransferredMegaBytes) / seconds
    let speed = round(megaBytesPerSecond * 100) / 100.0
    let time = remainingMegaBytes / speed
    lastTime = Date.now
    lastProgress = currentProgress
    lastTransferredMegaBytes = transferredMegaBytes
    return (speed, time)
  }

  private init() {}

  func initiate(with total: Int64) {
    reset()
    progress = Foundation.Progress(totalUnitCount: total)
  }

  func updateProgress(bytes: Int64) {
    transferredBytes += bytes
    progress.completedUnitCount = transferredBytes
    // Send progress in incremental intervals
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
    let speedTime = speedTime
    let fileProgress = Progress(
      value: currentProgress,
      speed: speedTime.speed,
      time: speedTime.time
    )
    trackProgress?(
      fileProgress,
      elapsedTime,
      progress.isCancelled
    )
  }

  func reset() {
    startTime = Date.now
    lastTime = Date.now
    lastProgress = 0
    transferredBytes = 0
    lastTransferredMegaBytes = 0
  }
}
