//
// AlertView.swift
// Created by Arpit Williams on 11/06/24.
// Copyright (c) 2024 StarKnights Technologies

import ComposableArchitecture
import SwiftUI

public struct AlertView: View {

  @Perception.Bindable
  var store: StoreOf<AlertStore>

  @State private var textInput = ""
  @FocusState private var textfieldActive: Bool
  @Environment(\.windowSize) var screenSize

  public var body: some View {
    WithPerceptionTracking {
      ZStack {
        transparentBackground
        alertView
      }
    }
  }

  var transparentBackground: some View {
    VStack { Color.black }
      .opacity(0.4)
      .ignoresSafeArea()
      .onTapGesture {
        if store.dismissOnTap {
          store.send(.dismiss(store.type))
        }
      }
      .onAppear {
        if store.autoDismiss {
          DispatchQueue.main.asyncAfter(
            deadline: .now() + .seconds(store.dismissDuration)
          ) { store.send(.dismiss(store.type)) }
        }
      }
  }

  var alertView: some View {
    VStack(alignment: .center, spacing: store.spacing) {
      if let title = store.title {
        Text(title)
          .font(iPad ? .title3.weight(.semibold) : .headline)
          .multilineTextAlignment(.center)
          .foregroundStyle(store.titleColor)
      }
      if let image = store.image {
        image
          .resizable()
          .scaledToFit()
          .frame(maxWidth: screenSize.width * (iPad ? 0.3 : 0.4))
      }
      if store.showProgress {
        ProgressView()
          .tint(Color(.leadLemon))
          .padding(.bottom, 4)
      }
      if let message = store.message {
        Text(message)
          .font(iPad ? .title3 : .body)
          .multilineTextAlignment(.center)
          .foregroundStyle(store.messageColor)
      }
      if store.showTextInput {
        TextField(store.textInputTitle ?? "", text: $textInput)
          .textFieldStyle(.roundedBorder)
          .foregroundStyle(Color(.licoriceLemon))
          .focused($textfieldActive)
          .onAppear {
            textfieldActive = true
            textInput = store.textInputValue
          }
          .onChange(of: textInput) { _ in
            store.send(.set(\.textInputValue, textInput))
          }
      }
      buttonView
    }
    .frame(maxWidth: .infinity)
    .padding(20)
    .shadow(radius: 2)
    .background(getLinearGradient([Color(.bananaLead), Color(.lemonLead)]))
    .clipShape(RoundedRectangle(cornerRadius: 8))
    .frame(width: screenSize.width * (iPad ? 0.5 : 0.8), alignment: .center)
    .position(x: screenSize.width / 2, y: screenSize.height / 2.4)
  }

  var buttonView: some View {
    HStack(spacing: 20) {
      Group {
        if let title = store.cancelButtonTitle {
          Button(title.uppercased(), role: .destructive) {
            store.send(.dismiss(store.type))
          }
        }
        if let title = store.mainButtonTitle {
          Button(title.uppercased()) {
            store.send(.done(store.type))
          }
          .foregroundStyle(Color(.licoriceLemon))
        }
      }
      .font(.callout.weight(.medium))
      .frame(maxWidth: .infinity, maxHeight: 40)
    }
  }
}

#Preview {
  AlertView(
    store: AlertStore.mockStore()
  )
  .setPreviewWindowSize()
}
