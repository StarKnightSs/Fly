//
// AlertView.swift
// Created by Arpit Williams on 25/05/24.
// Copyright (c) 2024 StarKnights Technologies

import SwiftUI

public struct AlertView: View {

  var title: String?
  var message: String?
  var image: Image?
  var mainButtonTitle: String?
  var cancelButtonTitle: String?
  var textInputTitle: String?
  var textInputValue: Binding<String>?
  var titleColor: Color = Color(.leadBanana)
  var messageColor: Color = Color(.licoriceLemon)
  var autoDismiss: Bool = false

  var done: (() -> Void)?
  var dismiss: (() -> Void)?

  @FocusState private var textfieldActive: Bool

  public var body: some View {
    GeometryReader { screen in
      ZStack {
        transparentBackground
        alertView
          .frame(width: screen.size.width * 0.8, alignment: .center)
          .position(x: screen.size.width / 2, y: screen.size.height / 2.4)
      }
    }
  }

  var transparentBackground: some View {
    VStack { Color.black }
      .opacity(0.4)
      .edgesIgnoringSafeArea(.bottom)
      .onTapGesture {
        dismiss?()
      }
      .onAppear {
        if autoDismiss {
          DispatchQueue.main.asyncAfter(
            deadline: .now() + .seconds(2)
          ) {
            dismiss?()
          }
        }
      }
  }

  var alertView: some View {
    VStack(alignment: .center, spacing: 20) {
      if let title {
        Text(title)
          .font(.headline)
          .multilineTextAlignment(.center)
      }
      if let message {
        Text(message)
          .font(.body)
          .multilineTextAlignment(.center)
      }
      if let image {
        image
          .resizable()
          .scaledToFit()
      }
      if let textInputValue {
        TextField(textInputTitle ?? "", text: textInputValue)
          .focused($textfieldActive)
          .textFieldStyle(.roundedBorder)
          .onAppear { textfieldActive = true }
          .foregroundStyle(Color(.licoriceLemon))
      }
      buttonView
    }
    .frame(maxWidth: .infinity)
    .padding(20)
    .shadow(radius: 2)
    .background(Color(.bananaLead))
    .clipShape(RoundedRectangle(cornerRadius: 8))
  }

  var buttonView: some View {
    HStack(spacing: 20) {
      Group {
        if let title = cancelButtonTitle {
          Button(title.uppercased(), role: .destructive) {
            dismiss?()
          }
        }
        if let title = mainButtonTitle {
          Button(title.uppercased()) {
            done?()
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
    title: "Title",
    message: "Message",
    mainButtonTitle: "OK",
    cancelButtonTitle: "CANCEL"
  )
}
