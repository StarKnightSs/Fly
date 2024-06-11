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
    VStack(spacing: 0) {
      filesView
    }
    .padding(.top, 1)
    .background(Color(.lemonLead))
    .navigationBarTitleDisplayMode(.inline)
    .environment(\.editMode, $store.editMode)
    .onChange(of: scenePhase) {
      if $0 == .active {
        store.send(.loadServer)
      }
    }
    .onAppear {
      store.send(.loadFiles)
      store.send(.loadServer)
    }
    .toolbar {
      Toolbar(store: store)
    }
  }

  var filesView: FilesView? {
    if let filesStore = store.scope(
      state: \.filesView,
      action: \.filesView.presented
    ) {
      FilesView(store: filesStore)
    } else {
      nil
    }
  }

  var alertView: AlertView? {
    if let alertStore = store.scope(
      state: \.alertView,
      action: \.alertView.presented
    ) {
      AlertView(store: alertStore)
    } else {
      nil
    }
  }

  var progressView: some View {
    ProgressView(value: store.progress.value, total: 100.0)
      .progressViewStyle(
        FileProgressView(store: store)
      )
  }
}
