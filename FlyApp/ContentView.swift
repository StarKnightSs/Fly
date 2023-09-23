//
//  ContentView.swift
//  Fly
//
//  Created by Arpit Williams on 23/09/23.
//

import FlyKit
import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundColor(.accentColor)
      Text(FlyKit().text)
    }
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
