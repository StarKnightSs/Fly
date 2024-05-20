//
// LaunchView.swift
// Created by Arpit Williams on 19/05/24.
// Copyright (c) 2024 StarKnights Technologies

import SwiftUI

public struct LaunchView: View {

  public init() {}

  public var body: some View {
    VStack {
      Spacer()
      Image("Monkey", bundle: .module)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .padding(20)

      Text("Fly Server")
        .font(.system(size: 40, weight: .semibold, design: .rounded))
        .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)

      Text("Offline File Transfer")
        .font(.system(.title, design: .rounded).weight(.semibold))

      Text("Over Wifi & Hotspot Networks")
        .foregroundColor(Color(hex: 0xEB512E))
        .font(.system(.headline, design: .rounded).weight(.medium))

      Spacer()
      Spacer()

      Text("Supersized File Transfer At The Speed Of Now")
        .multilineTextAlignment(.center)
        .font(.system(.callout, design: .rounded).weight(.regular))

      Text("Max Upload File Size: 100 GB")
        .font(.system(.headline, design: .rounded).weight(.semibold))

      Spacer()
    }
    .background(Color(hex: 0xF5EC00))
  }
}

struct LaunchView_Previews: PreviewProvider {
  static var previews: some View {
    LaunchView()
  }
}
