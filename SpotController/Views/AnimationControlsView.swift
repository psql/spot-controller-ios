//
//  AnimationControlsView.swift
//  SpotController
//
//  Created on 2026-02-08.
//

import SwiftUI

struct AnimationControlsView: View {
    @ObservedObject var api: SpotAPI
    @State private var isPlaying = false
    @State private var yaw: Double = 0.0
    @State private var roll: Double = 0.0
    @State private var pitch: Double = 0.0

    let animations = [
        Animation(name: "Wave", icon: "hand.wave", color: .blue),
        Animation(name: "Dance", icon: "music.note", color: .purple),
        Animation(name: "Bow", icon: "figure.wave", color: .green),
        Animation(name: "Spin", icon: "arrow.triangle.2.circlepath", color: .orange),
        Animation(name: "Sit Pretty", icon: "star", color: .yellow),
        Animation(name: "Stretch", icon: "figure.flexibility", color: .pink)
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 50))
                        .foregroundColor(.purple)

                    Text("Animations & Poses")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text("Make Spot perform tricks")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top)

                // Pre-built Animations
                VStack(spacing: 15) {
                    Text("Animations")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        ForEach(animations, id: \.name) { animation in
                            AnimationButton(animation: animation, api: api, isPlaying: $isPlaying)
                        }
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)

                // Pose Control
                VStack(spacing: 15) {
                    Text("Custom Pose")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(spacing: 20) {
                        PoseSlider(title: "Yaw", value: $yaw, range: -0.8...0.8, icon: "arrow.left.and.right")
                        PoseSlider(title: "Roll", value: $roll, range: -0.5...0.5, icon: "arrow.left.and.right.circle")
                        PoseSlider(title: "Pitch", value: $pitch, range: -0.5...0.5, icon: "arrow.up.and.down")

                        Button(action: applyPose) {
                            Text("Apply Pose")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .disabled(!api.isStanding || isPlaying)

                        Button(action: resetPose) {
                            Text("Reset to Neutral")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.regular)
                        .disabled(!api.isStanding || isPlaying)
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)

                if !api.isStanding {
                    Text("Spot must be standing to perform animations")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }

                Spacer()
            }
            .padding()
        }
    }

    private func applyPose() {
        isPlaying = true
        api.setPose(yaw: yaw, roll: roll, pitch: pitch) { success in
            isPlaying = false
            if !success {
                print("Failed to set pose")
            }
        }
    }

    private func resetPose() {
        yaw = 0.0
        roll = 0.0
        pitch = 0.0
        applyPose()
    }
}

struct Animation: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
}

struct AnimationButton: View {
    let animation: Animation
    @ObservedObject var api: SpotAPI
    @Binding var isPlaying: Bool

    var body: some View {
        Button(action: playAnimation) {
            VStack(spacing: 10) {
                Image(systemName: animation.icon)
                    .font(.title)
                    .foregroundColor(.white)

                Text(animation.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [animation.color, animation.color.opacity(0.7)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(12)
        }
        .disabled(!api.isStanding || isPlaying)
        .opacity((!api.isStanding || isPlaying) ? 0.5 : 1.0)
    }

    private func playAnimation() {
        isPlaying = true
        api.playAnimation(animation.name.lowercased().replacingOccurrences(of: " ", with: "_")) { success in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                isPlaying = false
            }
            if !success {
                print("Failed to play animation")
            }
        }
    }
}

struct PoseSlider: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let icon: String

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer()
                Text(String(format: "%.2f", value))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .monospacedDigit()
            }

            Slider(value: $value, in: range, step: 0.01)
                .tint(.blue)
        }
    }
}

#Preview {
    AnimationControlsView(api: SpotAPI())
}
