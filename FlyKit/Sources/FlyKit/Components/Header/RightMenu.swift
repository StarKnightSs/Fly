//
// RightMenu.swift
// Created by Arpit Williams on 26/05/24.
// Copyright (c) 2024 StarKnights Technologies

import FileServer
import SwiftUI

public struct RightMenu: View {

  @AppStorage("sortName")
  var sortName = SortType.date.name

  @AppStorage("sortAscending")
  var sortAscending = false

  @State var sortType: SortType = .date

  @EnvironmentObject private var viewModel: FlyViewModel

  private var isEditing: Bool {
    viewModel.editMode.isEditing
  }

  private var filesExist: Bool {
    viewModel.files.isEmpty == false
  }

  public var body: some View {
    Menu {
      if isEditing {
        ediMenu
      } else {
        fileMenu
      }
    } label: {
      Image(systemName: isEditing ?
        ellipsisCircleFill : folderFillBadgePlus
      )
      .foregroundStyle(Color(.leadLemon))
      .font(.headline)
      .animateBounce(isEditing)
    }
    .onAppear {
      sortType = SortType.type(for: sortName)
    }
  }

  var ediMenu: some View {
    Group {

      // Done
      Button {
        viewModel.editMode = .inactive
      } label: {
        Text("Done")
      }

      Divider()

      // Send Files
      Button {
        print("Send")
      } label: {
        Label("Send Files", systemImage: upArrow)
      }.disabled(viewModel.selectedFiles.isEmpty)

      // Delete
      Button(role: .destructive) {
        viewModel.removeSelectedFiles()
      } label: {
        Label("Delete", systemImage: trash)
      }
    }
  }

  var fileMenu: some View {
    Group {

      if filesExist {

        // Select
        Button {
          viewModel.editMode = .active
        } label: {
          Label("Select", systemImage: checkmarkCircle)
        }

        Divider()

        // Recieve Files
        Button {
          print("Receive")
        } label: {
          Label("Recieve Files", systemImage: downArrow)
        }
      }

      // Add Files
      Button {
        viewModel.showFilesPicker = true
      } label: {
        Label("Add Files", systemImage: docFill)
      }

      // Add Photos
      Button {
        viewModel.showPhotosPicker = true
      } label: {
        Label("Add Photos", systemImage: photo)
      }

      // Add Folder
      Button {
        viewModel.showFolderAlert = true
      } label: {
        Label("Add Folder", systemImage: folderFill)
      }

      // Sort Menu
      if filesExist {
        Divider()
        sortMenu
      }
    }
  }

  var sortMenu: some View {
    Picker(selection: $sortType.didSet(handleSort)) {
      ForEach(SortType.allCases, id: \.self) { type in
        if type == sortType {
          Label(
            type.name,
            systemImage: sortAscending ? chevronUp : chevronDown
          )
        } else {
          Text(type.name)
        }
      }
    } label: {
      Label("Sort By", systemImage: squareGrid3x3)
    }
    .pickerStyle(.menu)
  }

  func handleSort(newSort: SortType, oldSort: SortType) {
    if newSort == oldSort {
      sortAscending.toggle()
    } else {
      switch newSort {
      case .date, .size:
        sortAscending = false
      case .name, .type:
        sortAscending = true
      }
    }
    sortName = newSort.name
    viewModel.sortFiles(by: newSort, isAscending: sortAscending)
  }
}

#Preview(body: {
  RightMenu()
})
