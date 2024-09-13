//
// MusicView.swift
// Created by Arpit Williams on 13/09/24.
// Copyright (c) 2024 StarKnights Technologies

import SwiftUI

struct MusicView: View {

  let music: Music
  @State var isPlaying = true
  @State private var barHeights = Array(repeating: 0.4, count: 5)

  var body: some View {
    HStack(spacing: 16) {
      cover
      trackInfo
      if isPlaying {
        barView
      } else {
        trackDuration
      }
    }
    .onAppear {
      animateBars()
    }
  }

  var cover: some View {
    Group {
      AsyncImage(url: URL(string: music.cover)) {
        $0.resizable()
      } placeholder: {
        Image(systemName: "music.quarternote.3")
          .resizable()
          .padding(20)
          .foregroundStyle(Color(.leadLemon))
          .background(
            RoundedRectangle(cornerRadius: 20)
              .fill(Color(.lemonLead))
          )
      }
    }
    .aspectRatio(1, contentMode: .fit)
    .frame(width: iPad ? 120 : 80)
    .clipShape(RoundedRectangle(cornerRadius: 8))
    .shadow(radius: 4)
  }

  var trackInfo: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(music.title)
        .font(.system(iPad ? .title2 : .title3, design: .rounded).weight(.semibold))
      Text(music.album)
        .font(.system(iPad ? .body : .callout, design: .rounded).weight(.medium))
      Text(music.artist)
        .font(.system(iPad ? .body : .callout, design: .monospaced).weight(.light))
    }
    .lineLimit(1)
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  var trackDuration: some View {
    Text(music.duration)
      .font(.system(iPad ? .body : .callout, design: .rounded).weight(.light))
  }

  var barView: some View {
    HStack(spacing: 2) {
      ForEach(0 ... 4, id: \.self) { index in
        Rectangle()
          .fill(Color(.leadLemon))
          .frame(width: 2, height: barHeights[index] * 40)
          .cornerRadius(8)
      }
    }
  }

  private func animateBars() {
    withAnimation(.smooth.repeatForever(autoreverses: true)) {
      for index in 0 ... 4 {
        barHeights[index] = Double.random(in: 0.0 ... 0.4)
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        animateBars()
      }
    }
  }
}

#Preview {
  MusicView(music: .mock)
    .padding(.horizontal, 20)
}
