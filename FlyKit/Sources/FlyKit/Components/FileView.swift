//
// FileView.swift
// Created by Arpit Williams on 24/05/24.
// Copyright (c) 2024 StarKnights Technologies

import FileServer
import SwiftUI
import QuickLookThumbnailing

struct FileView: View {

  let file: File

  @State private var fileIcon: UIImage?

  var body: some View {
    VStack(spacing: 16) {
      HStack(spacing: 8) {
        fileIconView
        fileNameView
        Spacer()
      }
      VStack { Color.gray }
        .frame(height: 0.2)
    }
    .padding(.top, 16)
    .padding(.horizontal, 16)
    .onAppear {
      loadFilePreview()
    }
  }

  var fileIconView: some View {
    Group {
      if let fileIcon {
        Image(uiImage: fileIcon)
          .resizable()
          .aspectRatio(contentMode: .fill)

      } else {
        Image(systemName: file.isDirectory ? "folder.fill" : "doc.fill")
          .font(.title)
          .imageScale(.large)
          .foregroundStyle(Color(.leadBanana))
      }
    }
    .frame(width: 40)
  }

  var fileNameView: some View {
    VStack(alignment: .leading, spacing: 2) {
      Text(file.name)
        .font(.callout.weight(.medium))
      HStack(spacing: 2) {
        Text(file.createdAt)
        Text("-")
        Text(file.isDirectory ? file.itemCount : file.size)
      }.font(.caption2.monospacedDigit())
    }
  }

  func loadFilePreview() {
    Task {
      do {
        fileIcon = try await file.generatePreviewIcon()
      } catch {
        print(error)
      }
    }
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
