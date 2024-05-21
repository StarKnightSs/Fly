//
// FileView.swift
// Created by Arpit Williams on 17/05/24.
// Copyright (c) 2024 StarKnights Technologies

import Foundation
import QuickLook
import SwiftUI

#if os(iOS)
struct FileView: UIViewControllerRepresentable {

  let url: URL
  typealias UIViewControllerType = QLPreviewController

  func makeUIViewController(context: Context) -> QLPreviewController {
    let controller = QLPreviewController()
    controller.dataSource = context.coordinator
    controller.delegate = context.coordinator
    return controller
  }

  func updateUIViewController(_ uiViewController: QLPreviewController, context: Context) {}

  func makeCoordinator() -> Coordinator {
    return Coordinator(parent: self)
  }

  class Coordinator: NSObject, QLPreviewControllerDataSource, QLPreviewControllerDelegate {
    let parent: FileView

    init(parent: FileView) {
      self.parent = parent
    }

    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
      return 1
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
      return parent.url as QLPreviewItem
    }

    func previewController(_ controller: QLPreviewController, editingModeFor previewItem: QLPreviewItem) -> QLPreviewItemEditingMode {
      return .disabled
    }
  }
}
#endif
