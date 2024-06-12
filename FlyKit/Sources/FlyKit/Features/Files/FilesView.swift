//
// FilesView.swift
// Created by Arpit Williams on 11/06/24.
// Copyright (c) 2024 StarKnights Technologies

import ComposableArchitecture
import QuickLook
import SwiftUI

struct FilesView: View {

  @Perception.Bindable
  var store: StoreOf<FilesStore>

  @Dependency(\.dependencies)
  var dependencies

  var body: some View {
    WithPerceptionTracking {
      ZStack {
        mainView
        alertView
      }
    }
  }

  var mainView: some View {
    VStack {
      if store.files.isEmpty == false {
        listView
      } else {
        BlankView(
          showUploadView: $store.showUploadView
        )
      }
    }
    .sheet(isPresented: $store.showUploadView) {
      UploadView()
    }
    .quickLookPreview(
      $store.previewFile,
      in: store.allFilesURLs
    )
    .fileImporter(
      isPresented: $store.showFilesPicker,
      allowedContentTypes: dependencies.filesManager.supportedTypes,
      allowsMultipleSelection: true,
      onCompletion: { store.send(.importFiles($0)) }
    )
    .sheet(isPresented: $store.showPhotosPicker) {
      PhotosPicker(
        filesManager: dependencies.filesManager,
        onCompletion: { store.send(.importPhotos($0)) }
      )
      .ignoresSafeArea(edges: .bottom)
    }
  }

  var listView: some View {
    List(selection: $store.selectedFiles) {
      ForEach(store.files) {
        FileView(file: $0, store: store)
          .deleteDisabled(true)
          .listRowSeparator(.hidden)
          .listRowInsets(.init(.zero))
      }
    }
    .listStyle(.plain)
    .id(store.editMode)
    .background(Color(.snowLicorice))
    .environment(\.editMode, $store.editMode)
  }

  var alertView: AlertView? {
    guard let alertStore = store.scope(
      state: \.alertView,
      action: \.alertView.presented
    ) else { return nil }
    return AlertView(store: alertStore)
  }
}

#Preview {
  FilesView(
    store: FilesStore.loadStore()
  )
}
