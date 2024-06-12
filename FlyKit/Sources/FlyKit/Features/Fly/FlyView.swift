//
// FlyView.swift
// Created by Arpit Williams on 11/06/24.
// Copyright (c) 2024 StarKnights Technologies

import ComposableArchitecture
import SwiftUI

public struct FlyView: View {

  @Perception.Bindable
  var store: StoreOf<FlyStore>

  @Environment(\.scenePhase)
  private var scenePhase

  public init(store: StoreOf<FlyStore>) {
    self.store = store
  }

  public var body: some View {
    WithPerceptionTracking {
      NavigationView {
        ZStack {
          rootView
          alertView
          if store.showProgressView {
            progressView
          }
        }
      }
    }
  }

  var rootView: some View {
    VStack { filesView }
      .padding(.top, 1)
      .background(Color(.lemonLead))
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        Toolbar(
          store: filesStore ??
            FilesStore.mockStore()
        )
      }
      .onChange(of: scenePhase) {
        if $0 == .active {
          store.send(.loadServer)
        }
      }
      .onAppear {
        store.send(.loadFiles)
        store.send(.loadServer)
      }
  }

  var filesStore: StoreOf<FilesStore>? {
    store.scope(
      state: \.filesView,
      action: \.filesView.presented
    )
  }

  var filesView: FilesView? {
    guard let filesStore = store.scope(
      state: \.filesView,
      action: \.filesView.presented
    ) else { return nil }
    return FilesView(store: filesStore)
  }

  var alertView: AlertView? {
    guard let alertStore = store.scope(
      state: \.alertView,
      action: \.alertView.presented
    ) else { return nil }
    return AlertView(store: alertStore)
  }

  var progressView: some View {
    ProgressView(value: store.progress.value, total: 100.0)
      .progressViewStyle(
        ProgressStyle(store: store)
      )
  }
}
