//
// Music.swift
// Created by Arpit Williams on 13/09/24.
// Copyright (c) 2024 StarKnights Technologies

import Foundation

struct Music: Equatable, Identifiable {
  let id: UUID
  let url: URL
  let title: String
  let artist: String
  let album: String
  let cover: String
  let duration: String
}

extension Music {
  static let mock: Music = .init(
    id: UUID(),
    // swiftlint:disable:next force_unwrapping
    url: URL(string: "www.google.com")!,
    title: "Born To Love",
    artist: "Puremusic",
    album: "Serenades Of The Night",
    cover: "https://i1.sndcdn.com/artworks-000228530854-glt5w0-t500x500.jpg",
    duration: "6:37"
  )
}
