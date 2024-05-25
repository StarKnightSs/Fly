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
        .frame(maxWidth: 240)

      Text("Your Space is Empty")
        .font(.system(.title, design: .rounded))

      Text("Add your files & photos by clicking the \(Image(systemName: "folder.fill.badge.plus")) icon on the top right.")
        .padding(.vertical, 2)
        .padding(.horizontal, 20)
        .multilineTextAlignment(.center)
        .font(.system(.headline, design: .rounded).weight(.medium))

      Text("It's quick and easy ✩")
        .padding(.vertical, 4)
        .font(.system(.body, design: .rounded).weight(.semibold))

      Spacer()
    }
    .frame(maxWidth: .infinity)
    .background(Color(.lemonLicorice))
  }
}

#Preview(body: {
  BlankView()
})
