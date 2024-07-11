//
// LaunchView.swift
// Created by Arpit Williams on 19/05/24.
// Copyright (c) 2024 StarKnights Technologies

import FlyServer
import Resolver
import SwiftUI

public struct LaunchView: View {

  @Environment(\.windowSize) var screenSize

  /// Closure to get app config from launch view
  private var config: ((AppConfig?) -> Void)?
  public init(config: @escaping (AppConfig?) -> Void) {
    self.config = config
  }

  public var body: some View {
    VStack {
      Spacer()
      Image("Monkey", bundle: .module)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(maxWidth: screenSize.width * (iPad ? 0.6 : 1))
        .padding(.horizontal, 20)

      Text(String.fileFlyer)
        .font(.system(size: iPad ? 100 : 60, design: .rounded).weight(.heavy))
        .shadow(color: Color(.lemon).opacity(0.8), radius: 1, x: 2, y: 4)

      Text(String.easyShare)
        .font(.system(iPad ? .largeTitle : .title2, design: .rounded).weight(.semibold))

      Text(String.overWifi)
        .foregroundStyle(Color(.systemIndigo))
        .font(.system(iPad ? .title3 : .headline, design: .rounded).weight(.medium))

      Spacer()

      ProgressView()
        .tint(Color(.lead))
        .scaleEffect(iPad ? 2.8 : 2.0, anchor: .center)
        .progressViewStyle(CircularProgressViewStyle())

      Spacer()

      Text(String.speedOfNow)
        .multilineTextAlignment(.center)
        .font(.system(iPad ? .body : .callout, design: .rounded).weight(.medium))

      Text(String.maxFileSize)
        .foregroundStyle(Color(.systemPink))
        .font(.system(iPad ? .title3 : .headline, design: .rounded).weight(.semibold))

      Spacer()
    }
    .frame(maxWidth: .infinity)
    .onAppear { loadAppConfig() }
    .foregroundStyle(Color(.lead))
    .background(
      getLinearGradient([Color(.banana), Color(.lime), Color(.lemon)])
        .ignoresSafeArea()
    )
    .ignoresSafeArea()
  }

  private func loadAppConfig() {
    Task {
      let appConfigManager: AppConfigManagerProtocol? = Resolver.optional()
      let appConfig = try? await appConfigManager?.getConfig()
      try await Task.sleep(nanoseconds: 1_000_000_000)
      config?(appConfig)
    }
  }
}

struct LaunchView_Previews: PreviewProvider {
  static var previews: some View {
    LaunchView { _ in }
      .setPreviewWindowSize()
  }
}
