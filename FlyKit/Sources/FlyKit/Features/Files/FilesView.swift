//
// FilesView.swift
// Created by Arpit Williams on 11/06/24.
// Copyright (c) 2024 StarKnights Technologies

import AdMob
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
        rootView
        alertView
      }
    }
  }

  var rootView: some View {
    NavigationView {
      VStack(spacing: 0) {
        if store.files.isEmpty == false {
          listView
        } else {
          BlankView(
            showUploadView: $store.showUploadView
          )
        }
        if store.showBannerView {
          bannerView
        }
      }
      .padding(.top, 1)
      .background(Color(.lemonLead))
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        Toolbar(store: store)
      }
      .onAppear {
        store.send(.loadFiles)
      }
    }
    .navigationViewStyle(.stack)
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
    .sheet(item: $store.scope(state: \.scanQRCodeView, action: \.scanQRCodeView)) {
      ScanQRView(store: $0)
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
    .animation(iOS16 ? .easeInOut : .none, value: store.selectedFolders.count)
  }

  var alertView: AlertView? {
    guard let alertStore = store.scope(
      state: \.alertView,
      action: \.alertView.presented
    ) else { return nil }
    return AlertView(store: alertStore)
  }

  var bannerView: some View {
    BannerView(showBanner: { store.showBanner = $0 })
      .padding(.top, store.showBanner ? 2 : 0)
      .frame(height: store.showBanner ? 40 : 0.2)
      .background(store.showBanner ? Color(.leadLemon) : .clear)
      .modify {
        if store.showBanner {
          $0.ignoresSafeArea(edges: .bottom)
        } else {
          $0.clipped()
        }
      }
  }
}

#Preview {
  FilesView(
    store: FilesStore.mockStore()
  )
  .setPreviewWindowSize()
}
