//
// MusicListStore.swift
// Created by Arpit Williams on 13/09/24.
// Copyright (c) 2024 StarKnights Technologies

import ComposableArchitecture
import FlyServer
import Foundation
import SwiftUI

@Reducer
public struct MusicListStore {

  @ObservableState
  public struct State: Equatable {
    var tracks = [Music]()
  }

  public enum Action: BindableAction {
    case loadTracks
    case dismiss
    case binding(BindingAction<State>)
  }

  @Dependency(\.dismiss) var dismiss

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .loadTracks:
        state.tracks = [.mock, .mock, .mock, .mock, .mock, .mock, .mock, .mock]
        return .none
      case .binding:
        return .none
      case .dismiss:
        return .run { _ in
          await self.dismiss(animation: .default)
        }
      }
    }
  }
}

// MARK: Mock Store

extension MusicListStore {
  static func mockStore() -> StoreOf<Self> {
    .init(initialState: State(tracks: [.mock, .mock])) {
      MusicListStore()
    }
  }
}
