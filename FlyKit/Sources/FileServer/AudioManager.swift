//
// AudioManager.swift
// Created by Arpit Williams on 21/05/24.
// Copyright (c) 2024 StarKnights Technologies

import AVFoundation
import Foundation

final class AudioManager {

  var player: AVAudioPlayer?
  static let shared = AudioManager()
  let session = AVAudioSession.sharedInstance()

  private init() {
    try? session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
  }

  func play() {
    guard let path = Bundle.module.path(forResource: "Sound", ofType: "m4a"),
          let url = URL(string: path)
    else { return }
    do {
      try? session.setActive(true)
      player = try AVAudioPlayer(contentsOf: url)
      player?.numberOfLoops = -1
      player?.play()
    } catch let error as NSError {
      print("Failed to play sound: \(error)")
    }
  }

  func stop() {
    player?.stop()
    try? session.setActive(false, options: .notifyOthersOnDeactivation)
  }
}
