//
// BlankView.swift
// Created by Arpit Williams on 24/05/24.
// Copyright (c) 2024 StarKnights Technologies

import ComposableArchitecture
import SwiftUI

public struct BlankView: View {

  let store: StoreOf<FilesStore>

  public var body: some View {
    VStack {

      Spacer()

      Image("Monkey", bundle: .module)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(maxWidth: 240)

      Text("Space is Empty 🧑‍🚀")
        .font(.system(.title, design: .rounded))

      Text("Tap the \(Image(systemName: folderFillBadgePlus)) icon on the top right,\nto add your files & photos")
        .padding(20)
        .multilineTextAlignment(.center)
        .font(.system(.headline, design: .rounded).weight(.medium))

      Text("Or tap below to drop files here,\nIt's quick and easy \(Image(systemName: downArrow))")
        .padding(16)
        .multilineTextAlignment(.center)
        .font(.system(.body, design: .rounded).weight(.semibold))

      Spacer()

      Button("Drop Files", systemImage: downArrow) {
        store.showUploadView = true
      }
      .textCase(.uppercase)
      .padding(.vertical, 16)
      .padding(.horizontal, 20)
      .font(.system(.headline, design: .rounded).weight(.semibold))
      .foregroundStyle(Color(.lemonLead))
      .background(
        RoundedRectangle(cornerRadius: 20)
          .fill(Color(.leadLemon))
      )

      Spacer()
        .frame(height: 20)
    }
    .frame(maxWidth: .infinity)
    .background(Color(.lemonLicorice))
  }
}

#Preview(body: {
  BlankView(
    store: FilesStore.mockStore()
  )
})
