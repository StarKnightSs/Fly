//
// FileView.swift
// Created by Arpit Williams on 24/05/24.
// Copyright (c) 2024 StarKnights Technologies

import ComposableArchitecture
import FlyServer
import QuickLookThumbnailing
import SwiftUI

struct FileView: View {

  let file: File
  let store: StoreOf<FilesStore>

  @State private var fileIcon: UIImage?

  private var isEditing: Bool {
    store.editMode.isEditing
  }

  var body: some View {
    WithPerceptionTracking {
      VStack(spacing: 8) {
        HStack(spacing: 8) {
          Group {
            fileIconView
            fileNameView
          }
          .contentShape(Rectangle())
          .onTapGesture { openFile() }

          if isEditing == false {
            fileMenuView
          }
        }
        Divider()
      }
      .padding(.top, 8)
      .padding(.horizontal, 16)
      .contextMenu { menuItems }
      .onAppear {
        if fileIcon == nil {
          loadFilePreview()
        }
      }
      .swipeActions(allowsFullSwipe: false) {
        if #available(iOS 16, *) {
          deleteButton
        } else {
          EmptyView()
        }
      }
      .modify {
        if #available(iOS 17, *) {
          $0.selectionDisabled(isEditing == false)
        } else {
          $0
        }
      }
    }
  }

  var fileIconView: some View {
    VStack {
      if let fileIcon {
        Image(uiImage: fileIcon)
          .resizable()
          .scaledToFit()
          .frame(width: 44, height: 44)
          .clipShape(RoundedRectangle(cornerRadius: 2))

      } else {
        Image(systemName: file.icon)
          .font(.title)
          .imageScale(.large)
          .frame(width: 44, height: 44)
          .foregroundStyle(Color(.leadBanana))
      }
    }
  }

  var fileNameView: some View {
    VStack(alignment: .leading, spacing: 2) {
      Text(file.name)
        .font(.callout)
        .lineLimit(1)
        .frame(maxWidth: .infinity, alignment: .leading)
      HStack(spacing: 2) {
        Text(file.createdAt)
        Text("-")
        Text(file.isDirectory ? file.itemCount : file.size)
      }
      .font(.caption2.weight(.light))
    }
  }

  var fileMenuView: some View {
    Menu {
      menuItems
    } label: {
      Image(systemName: ellipsisCircleFill)
        .padding(4)
        .imageScale(.large)
        .symbolRenderingMode(.hierarchical)
        .foregroundStyle(Color(.leadLemon))
    }
  }

  var menuItems: some View {
    Group {
      sendButton
      Divider()
      AnyView(shareButton)
      previewButton
      copyButton
      moveButton
      renameButton
      deleteButton
    }
  }

  var sendButton: some View {
    Button {
      print("Send")
    } label: {
      Label("Send", systemImage: upArrow)
    }
  }

  var shareButton: any View {
    if #available(iOS 16.0, *) {
      ShareLink(item: file.url) {
        Label("Share", systemImage: squareAndArrowUp)
      }
    } else {
      Button {
        share([file.url])
      } label: {
        Label("Share", systemImage: squareAndArrowUp)
      }
    }
  }

  var previewButton: some View {
    Button {
      openFile()
    } label: {
      Label("Preview", systemImage: eye)
    }
  }

  var copyButton: some View {
    Button {
      store.send(.copy(file))
    } label: {
      Label("Copy", systemImage: docOnDoc)
    }
  }

  var moveButton: some View {
    Button {
      store.send(.move(file))
    } label: {
      Label("Move", systemImage: folder)
    }
  }

  var renameButton: some View {
    Button {
      store.send(.showFileRenameAlert(file))
    } label: {
      Label("Rename", systemImage: pencil)
    }
  }

  var deleteButton: some View {
    Button(role: .destructive) {
      store.send(.removeFile(file.url))
    } label: {
      Label("Delete", systemImage: trashCircle)
    }
  }

  func loadFilePreview() {
    Task {
      fileIcon = try? await file.generatePreviewIcon()
    }
  }

  func openFile() {
    guard isEditing == false else { return }
    if file.isDirectory {
      store.selectedFolders.append(file.url)
      store.send(.loadFolder)
    } else {
      store.previewFile = file.url
    }
  }
}

#Preview {
  FileView(
    file: .mockFile,
    store: FilesStore.mockStore()
  ).previewLayout(.sizeThatFits)
}

#Preview {
  FileView(
    file: .mockFolder,
    store: FilesStore.mockStore()
  ).previewLayout(.sizeThatFits)
}
