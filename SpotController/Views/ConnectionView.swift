//
//  ConnectionView.swift
//  SpotController
//
//  Created on 2026-02-08.
//

import SwiftUI

struct ConnectionView: View {
    @ObservedObject var api: SpotAPI
    @Binding var isConnected: Bool
    @State private var serverURL: String = "http://192.168.100.245:8081"
    @State private var isConnecting = false
    @State private var showError = false

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            // Title
            VStack(spacing: 10) {
                Image(systemName: "antenna.radiowaves.left.and.right")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)

                Text("Spot Controller")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Connect to your Spot robot")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Connection Form
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Server URL")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    TextField("http://localhost:8081", text: $serverURL)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                        .keyboardType(.URL)
                        .disabled(isConnecting)
                }

                if showError && !api.errorMessage.isEmpty {
                    Text(api.errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }

                Button(action: connectToSpot) {
                    if isConnecting {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Connect")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(isConnecting || serverURL.isEmpty)
            }
            .padding(.horizontal, 40)

            Spacer()
        }
        .padding()
    }

    private func connectToSpot() {
        isConnecting = true
        showError = false
        api.baseURL = serverURL

        api.connect { success in
            isConnecting = false
            if success {
                isConnected = true
            } else {
                showError = true
            }
        }
    }
}

#Preview {
    ConnectionView(api: SpotAPI(), isConnected: .constant(false))
}
