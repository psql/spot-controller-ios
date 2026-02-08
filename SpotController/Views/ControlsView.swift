//
//  ControlsView.swift
//  SpotController
//
//  Created on 2026-02-08.
//

import SwiftUI

struct ControlsView: View {
    @ObservedObject var api: SpotAPI
    @Binding var isConnected: Bool
    @State private var showingDisconnectAlert = false
    @State private var selectedTab = 0

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Spot Controller")
                    .font(.title2)
                    .fontWeight(.bold)

                Spacer()

                Button(action: { showingDisconnectAlert = true }) {
                    Image(systemName: "power")
                        .font(.title3)
                        .foregroundColor(.red)
                }
            }
            .padding()
            .background(Color(uiColor: .systemBackground))

            Divider()

            // Tab Bar
            Picker("", selection: $selectedTab) {
                Text("Main").tag(0)
                Text("Gait").tag(1)
                Text("Animations").tag(2)
            }
            .pickerStyle(.segmented)
            .padding()

            // Content
            TabView(selection: $selectedTab) {
                MainControlsTab(api: api)
                    .tag(0)

                GaitSelectionView(api: api)
                    .tag(1)

                AnimationControlsView(api: api)
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .alert("Disconnect", isPresented: $showingDisconnectAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Disconnect", role: .destructive) {
                disconnect()
            }
        } message: {
            Text("Are you sure you want to disconnect from Spot?")
        }
    }

    private func disconnect() {
        api.disconnect { success in
            if success {
                isConnected = false
            }
        }
    }
}

struct MainControlsTab: View {
    @ObservedObject var api: SpotAPI
    @State private var isProcessing = false

    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Status Card
                VStack(spacing: 12) {
                    HStack {
                        StatusIndicator(title: "Power", isActive: api.isPowered)
                        Spacer()
                        StatusIndicator(title: "Standing", isActive: api.isStanding)
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)

                // Power Controls
                VStack(spacing: 15) {
                    Text("Power Controls")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    HStack(spacing: 15) {
                        ControlButton(
                            title: "Power On",
                            icon: "power",
                            color: .green,
                            isDisabled: api.isPowered || isProcessing
                        ) {
                            performAction { api.powerOn(completion: $0) }
                        }

                        ControlButton(
                            title: "Power Off",
                            icon: "power",
                            color: .orange,
                            isDisabled: !api.isPowered || isProcessing
                        ) {
                            performAction { api.powerOff(completion: $0) }
                        }
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)

                // Stance Controls
                VStack(spacing: 15) {
                    Text("Stance Controls")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    HStack(spacing: 15) {
                        ControlButton(
                            title: "Stand",
                            icon: "figure.stand",
                            color: .blue,
                            isDisabled: !api.isPowered || api.isStanding || isProcessing
                        ) {
                            performAction { api.stand(completion: $0) }
                        }

                        ControlButton(
                            title: "Sit",
                            icon: "figure.walk",
                            color: .purple,
                            isDisabled: !api.isPowered || !api.isStanding || isProcessing
                        ) {
                            performAction { api.sit(completion: $0) }
                        }
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)

                // Movement Controls
                if api.isStanding {
                    VStack(spacing: 15) {
                        Text("Movement Controls")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        VStack(spacing: 10) {
                            // Forward
                            MovementButton(direction: "forward", icon: "arrow.up", api: api)

                            HStack(spacing: 10) {
                                // Left
                                MovementButton(direction: "left", icon: "arrow.left", api: api)

                                // Stop (middle)
                                Button(action: {
                                    performAction { api.move(direction: "stop", completion: $0) }
                                }) {
                                    Image(systemName: "stop.fill")
                                        .font(.title2)
                                        .frame(width: 70, height: 70)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(10)
                                }

                                // Right
                                MovementButton(direction: "right", icon: "arrow.right", api: api)
                            }

                            // Backward
                            MovementButton(direction: "backward", icon: "arrow.down", api: api)
                        }
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(12)
                }

                // Emergency Stop
                VStack(spacing: 15) {
                    Button(action: {
                        performAction { api.eStop(completion: $0) }
                    }) {
                        HStack {
                            Image(systemName: "exclamationmark.octagon.fill")
                                .font(.title2)
                            Text("EMERGENCY STOP")
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                }
            }
            .padding()
        }
    }

    private func performAction(_ action: @escaping (@escaping (Bool) -> Void) -> Void) {
        isProcessing = true
        action { success in
            isProcessing = false
            if !success {
                print("Action failed")
            }
        }
    }
}

struct StatusIndicator: View {
    let title: String
    let isActive: Bool

    var body: some View {
        HStack {
            Circle()
                .fill(isActive ? Color.green : Color.gray)
                .frame(width: 12, height: 12)
            Text(title)
                .font(.subheadline)
        }
    }
}

struct ControlButton: View {
    let title: String
    let icon: String
    let color: Color
    let isDisabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title)
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(isDisabled ? Color.gray.opacity(0.3) : color.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .disabled(isDisabled)
    }
}

struct MovementButton: View {
    let direction: String
    let icon: String
    @ObservedObject var api: SpotAPI

    var body: some View {
        Button(action: {
            api.move(direction: direction) { _ in }
        }) {
            Image(systemName: icon)
                .font(.title2)
                .frame(width: 70, height: 70)
                .background(Color.blue.opacity(0.7))
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}

#Preview {
    ControlsView(api: SpotAPI(), isConnected: .constant(true))
}
