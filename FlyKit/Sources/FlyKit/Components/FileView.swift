//
// FileView.swift
// Created by Arpit Williams on 24/05/24.
// Copyright (c) 2024 StarKnights Technologies

import FlyServer
import QuickLookThumbnailing
import SwiftUI

struct FileView: View {

  let file: File

  @State private var fileIcon: UIImage?
  @EnvironmentObject private var viewModel: FlyViewModel

  private var isEditing: Bool {
    viewModel.editMode.isEditing
  }

  var body: some View {
    VStack(spacing: 8) {
      HStack(spacing: 8) {
        Group {
          fileIconView
          fileNameView
        }.onTapGesture {
          quickLookFile()
        }
        Spacer()
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
      deleteButton
    }
    .modify {
      if #available(iOS 17, *) {
        $0.selectionDisabled(isEditing == false)
      } else {
        $0
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
      HStack(spacing: 2) {
        Text(file.createdAt)
        Text("-")
        Text(file.isDirectory ? file.itemCount : file.size)
      }.font(.caption2.weight(.light))
    }
  }

  var fileMenuView: some View {
    Menu {
      menuItems
    } label: {
      Image(systemName: ellipsis)
        .padding(.trailing, 4)
        .frame(width: 20, height: 20)
        .foregroundStyle(Color(.leadBanana))
    }
  }

  var menuItems: some View {
    Group {
      sendButton
      Divider()
      AnyView(shareButton)
      previewButton
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
      quickLookFile()
    } label: {
      Label("Preview", systemImage: eye)
    }
  }

  var renameButton: some View {
    Button {
      viewModel.showRenameAlert(for: file)
    } label: {
      Label("Rename", systemImage: pencil)
    }
  }

  var deleteButton: some View {
    Button(role: .destructive) {
      viewModel.removeFile(at: file.url)
    } label: {
      Label("Delete", systemImage: trashCircle)
    }
  }

  func loadFilePreview() {
    Task {
      fileIcon = try? await file.generatePreviewIcon()
    }
  }

  func quickLookFile() {
    guard file.isDirectory == false, isEditing == false else { return }
    viewModel.previewFile = file.url
  }
}

#Preview {
  FileView(file: .mockFile)
    .previewLayout(.sizeThatFits)
}

#Preview {
  FileView(file: .mockFolder)
    .previewLayout(.sizeThatFits)
}
