//
// MusicListView.swift
// Created by Arpit Williams on 13/09/24.
// Copyright (c) 2024 StarKnights Technologies

import ComposableArchitecture
import SwiftUI

struct MusicListView: View {

  @Perception.Bindable
  var store: StoreOf<MusicListStore>

  var body: some View {
    NavigationView {
      trackList
        .navigationTitle("Music 🎵")
        .onAppear { store.send(.loadTracks) }
        .modify { view in
          WithPerceptionTracking { view }
        }
    }
  }

  var trackList: some View {
    List(store.tracks) {
      MusicView(music: $0)
        .listRowBackground(Color.clear)
    }
    .listStyle(.plain)
    .background(
      getLinearGradient([Color(.lemonLead), Color(.limeLicorice)])
        .ignoresSafeArea()
    )
  }
}

#Preview {
  MusicListView(
    store: MusicListStore.mockStore()
  )
}
