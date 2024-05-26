//
// EditMenu.swift
// Created by Arpit Williams on 26/05/24.
// Copyright (c) 2024 StarKnights Technologies

import SwiftUI

public struct EditMenu: View {

  @EnvironmentObject private var viewModel: FlyViewModel

  public var body: some View {
    Menu(
      content: {
        Button(
          action: { viewModel.editMode = .inactive },
          label: { Label("Done", systemImage: "checkmark") }
        )
        Button(
          action: {},
          label: { Label("Send", systemImage: "arrow.up.square") }
        )

        Menu("More Options", systemImage: "ellipsis.rectangle.fill") {
          Button(
            action: {},
            label: { Text("Copy") }
          )

          Button(
            action: {},
            label: { Text("Move") }
          )

          Button(
            action: {},
            label: { Text("Delete") }
          )

          Button(
            action: {},
            label: { Text("Compress") }
          )

          Button(
            action: {},
            label: { Text("Size") }
          )
        }
      },
      label: {
        Image(systemName: "ellipsis.circle.fill")
          .foregroundStyle(Color(.leadLemon))
          .font(.headline)
      }
    )
  }
}

#Preview(body: {
  EditMenu()
})
