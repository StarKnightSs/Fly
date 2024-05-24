//
// BlankView.swift
// Created by Arpit Williams on 24/05/24.
// Copyright (c) 2024 StarKnights Technologies

import SwiftUI

public struct BlankView: View {

  public var body: some View {
    VStack {

      Spacer()

      Image("Monkey", bundle: .module)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(maxWidth: 300)

      Text("Your Space is Empty")
        .frame(maxWidth: .infinity)
        .font(.system(.title, design: .rounded))

      Text("Let's get started !")
        .padding(.vertical, 2)
        .font(.system(.title3, design: .rounded).weight(.medium))

      Text("Add your files & photos by clicking the \(Image(systemName: "folder.fill.badge.plus")) icon on the top right.")
        .padding(.vertical, 8)
        .padding(.horizontal, 20)
        .multilineTextAlignment(.center)
        .font(.system(.headline, design: .rounded).weight(.medium))

      Text("It's quick and easy 🐒")
        .padding(.vertical, 8)
        .font(.system(.body, design: .rounded).weight(.semibold))

      Spacer()
    }
    .background(Color(.lemonLicorice))
  }
}

#Preview(body: {
  BlankView()
})
