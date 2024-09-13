//
// SlideMenu.swift
// Created by Arpit Williams on 02/09/24.
// Copyright (c) 2024 StarKnights Technologies

import SwiftUI

struct SlideMenu: View {

  @Binding var isOpen: Bool

  var music: (() -> Void)?
  var dismiss: (() -> Void)?

  @Environment(\.windowSize) var screenSize
  @Environment(\.colorScheme) var colorMode

  @AppStorage("isDarkMode") private var isDarkMode: Bool?

  var body: some View {
    ZStack(alignment: .topLeading) {
      if isOpen {
        backgroundView
        menuView
      }
    }
    .animation(.bouncy.speed(2.4), value: isOpen)
  }

  var backgroundView: some View {
    VStack { Color.black }
      .opacity(0.2)
      .ignoresSafeArea()
      .transition(.opacity)
      .onTapGesture { dismiss?() }
  }

  var menuView: some View {
    VStack(spacing: 40) {
      monkey
      darkMode
      musicLibrary
      audioReader
      rateApp
    }
    .frame(width: screenSize.width * 0.2)
    .background(Color(.leadBanana))
    .clipShape(Capsule())
    .transition(.move(edge: .leading))
  }

  var monkey: some View {
    VStack(spacing: 8) {
      Image("Monkey", bundle: .module)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(maxWidth: iPad ? 80 : 40)
        .padding(8)
        .background(Color(.lemonLead))
        .clipShape(Capsule())

      Text(appVersion())
        .foregroundStyle(Color(.lemonLead))
        .font(.system(.footnote, design: .rounded))
    }
    .padding(.top, 20)
  }

  var darkMode: some View {
    MenuButton(
      image: colorMode == .dark ? lightBulbOff : lightBulbOn,
      title: colorMode == .dark ? "Dark Mode" : "Light Mode",
      action: { isDarkMode = colorMode == .dark }
    )
  }

  var musicLibrary: some View {
    MenuButton(
      image: "music.quarternote.3",
      title: "Music",
      action: {
        music?()
        dismiss?()
      }
    )
  }

  var audioReader: some View {
    MenuButton(
      image: "books.vertical.fill",
      title: "Books",
      action: {}
    )
  }

  var rateApp: some View {
    MenuButton(
      image: "star.fill",
      title: "Rate App",
      action: {}
    )
    .padding(.bottom, 30)
  }
}

#Preview {
  SlideMenu(isOpen: .constant(true))
    .setPreviewWindowSize()
}
