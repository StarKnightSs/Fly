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
    Image(systemName: isSelected ?
      checkmarkCircleFill :
      checkmarkCircle
    )
    .onTapGesture {
      isSelected ?
        viewModel.deSelectAllFiles() :
        viewModel.selectAllFiles()
      isSelected.toggle()
    }
    .offset(x: 2)
    .font(.headline)
    .foregroundStyle(Color(.leadLemon))
  }

  var lightBulb: some View {
    Image(systemName: colorMode == .dark ?
      lightBulbOff :
      lightBulbOn
    )
    .onTapGesture {
      isDarkMode = colorMode == .dark
    }
    .font(.headline)
    .foregroundStyle(Color(.leadLemon))
  }

  var gearShape: some View {
    Image(systemName: gearshapeFill)
      .offset(y: 1.2)
      .font(.headline)
      .foregroundStyle(Color(.leadLemon))
  }
}

#Preview(body: {
  LeftMenu()
})
