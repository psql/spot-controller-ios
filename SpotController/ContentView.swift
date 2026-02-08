//
//  ContentView.swift
//  SpotController
//
//  Created on 2026-02-08.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var api = SpotAPI()
    @State private var isConnected = false

    var body: some View {
        NavigationView {
            if isConnected {
                ControlsView(api: api, isConnected: $isConnected)
            } else {
                ConnectionView(api: api, isConnected: $isConnected)
            }
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    ContentView()
}
