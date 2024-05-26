//
// FileView.swift
// Created by Arpit Williams on 24/05/24.
// Copyright (c) 2024 StarKnights Technologies

import FileServer
import QuickLookThumbnailing
import SwiftUI

struct FileView: View {

  let file: File

  @State private var fileIcon: UIImage?

  var body: some View {
    VStack(spacing: 8) {
      HStack(spacing: 8) {
        fileIconView
        fileNameView
        Spacer()
        fileSelectView
      }
      Divider()
    }
    .padding(.top, 8)
    .padding(.horizontal, 16)
    .onAppear {
      if fileIcon == nil {
        loadFilePreview()
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
        .font(.footnote)
      HStack(spacing: 2) {
        Text(file.createdAt)
        Text("-")
        Text(file.isDirectory ? file.itemCount : file.size)
      }.font(.caption2.weight(.light))
    }
  }

  var fileSelectView: some View {
    Image(
      systemName: iOS16 ? "ellipsis.rectangle" : "ellipsis.circle.fill"
    )
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
