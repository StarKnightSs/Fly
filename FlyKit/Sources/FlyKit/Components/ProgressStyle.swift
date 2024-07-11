//
// ProgressStyle.swift
// Created by Arpit Williams on 08/06/24.
// Copyright (c) 2024 StarKnights Technologies

import ComposableArchitecture
import FlyServer
import SwiftUI

struct ProgressStyle: ProgressViewStyle {

  let store: StoreOf<FlyStore>

  @Environment(\.windowSize) var screenSize

  var speed: String {
    store.progress.speed
      .formatted(.number.precision(.fractionLength(2)))
  }

  var time: String {
    let seconds = store.progress.time
    return format(seconds)
  }

  func makeBody(configuration: Configuration) -> some View {
    WithPerceptionTracking {
      ZStack {
        transparentBackground
        VStack(spacing: 0) {
          title
          progressView(configuration.fractionCompleted ?? 0)
          subTitle
          footNote
        }
        .padding(.vertical, 20)
        .frame(maxWidth: screenSize.width * (iPad ? 0.6 : 1))
        .background(getLinearGradient([Color(.bananaLead), Color(.lemonLicorice)]))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: Color(.licoriceLemon), radius: 8)
        .padding(.horizontal, 20)
        .offset(y: -30)
      }
    }
  }

  var transparentBackground: some View {
    VStack { Color.black }
      .opacity(0.4)
      .ignoresSafeArea()
      .allowsHitTesting(true)
  }

  var title: some View {
    Text(String.dataInTransit)
      .textCase(.uppercase)
      .padding(.vertical, 4)
      .foregroundStyle(Color(.leadLemon))
      .font(.system(iPad ? .title3 : .headline, design: .rounded)
        .weight(.bold)
      )
  }

  func progressView(_ progress: Double) -> some View {
    GeometryReader { geometry in
      RoundedRectangle(cornerRadius: 8)
        .stroke(Color(.pinkLime), lineWidth: 8)
        .background(alignment: .leading) {
          RoundedRectangle(cornerRadius: 0)
            .modify {
              if #available(iOS 16, *) {
                $0.fill(Color(.leadLemon).gradient)
              } else {
                $0.fill(Color(.leadLemon))
              }
            }
            .frame(width: geometry.size.width * progress)
            .overlay(
              Text("\(progress.formatted(.percent))")
                .lineLimit(1)
                .font(.system(iPad ? .title3 : .headline, design: .rounded))
                .foregroundStyle(Color(.lemonLead))
            )
        }
    }
    .frame(height: 60)
    .padding(20)
  }

  var subTitle: some View {
    HStack(spacing: 4) {
      Text(String(format: String.speed, speed))
      Spacer()
      Text(String(format: String.time, time))
    }
    .padding(.top, 4)
    .padding(.horizontal, 20)
    .foregroundStyle(Color(.leadLime))
    .font(.system(iPad ? .callout : .caption, design: .rounded).weight(.medium))
  }

  var footNote: some View {
    Text(String.pleaseDontKill)
      .padding(.top, 20)
      .foregroundStyle(Color(.leadLemon))
      .font(.system(iPad ? .subheadline : .footnote, design: .rounded).weight(.light))
  }
}

#Preview(body: {
  ProgressView(value: 80, total: 100)
    .progressViewStyle(
      ProgressStyle(
        store: FlyStore.mockStore()
      )
    ).setPreviewWindowSize()
})
