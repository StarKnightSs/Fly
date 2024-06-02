//
// LeftMenu.swift
// Created by Arpit Williams on 31/05/24.
// Copyright (c) 2024 StarKnights Technologies

import FileServer
import SwiftUI

public struct LeftMenu: View {

  @State private var isSelected = false
  @Environment(\.colorScheme) var colorMode
  @EnvironmentObject private var viewModel: FlyViewModel
  @AppStorage("isDarkMode") private var isDarkMode: Bool?

  private var isEditing: Bool {
    viewModel.editMode.isEditing
  }

  public var body: some View {
    if isEditing {
      checkMark
    } else {
      lightBulb
    }
  }

  var checkMark: some View {
    Button(
      action: {
        isSelected ?
          viewModel.deSelectAllFiles() :
          viewModel.selectAllFiles()
        isSelected.toggle()
      },
      label: {
        Image(systemName: isSelected ?
          checkmarkCircleFill :
          checkmarkCircle
        )
        .font(.headline)
        .foregroundStyle(Color(.leadLemon))
        .animateReplace()
        .onDisappear {
          isSelected = false
          viewModel.deSelectAllFiles()
        }
      })
  }

  var lightBulb: some View {
    Button(
      action: { isDarkMode = colorMode == .dark },
      label: {
        Image(systemName: colorMode == .dark ?
          lightBulbOff : lightBulbOn
        )
        .font(.headline)
        .foregroundStyle(Color(.leadLemon))
        .animateReplace()
      })
  }
}

#Preview(body: {
  LeftMenu()
})
