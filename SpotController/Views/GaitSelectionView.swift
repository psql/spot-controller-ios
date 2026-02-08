//
//  GaitSelectionView.swift
//  SpotController
//
//  Created on 2026-02-08.
//

import SwiftUI

struct GaitSelectionView: View {
    @ObservedObject var api: SpotAPI
    @State private var selectedGait = "Auto"
    @State private var isApplying = false

    let gaits = [
        "Auto",
        "Walk",
        "Trot",
        "Crawl",
        "Amble"
    ]

    let gaitDescriptions: [String: String] = [
        "Auto": "Automatically selects the best gait based on terrain and speed",
        "Walk": "Slow and stable, best for precision and rough terrain",
        "Trot": "Faster pace with a bouncing motion, good for smooth surfaces",
        "Crawl": "Very slow and careful, maximum stability",
        "Amble": "Smooth and energy-efficient for moderate speeds"
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "figure.walk")
                        .font(.system(size: 50))
                        .foregroundColor(.blue)

                    Text("Gait Selection")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text("Choose how Spot moves")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top)

                // Gait Picker
                VStack(spacing: 15) {
                    Text("Available Gaits")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Picker("Gait", selection: $selectedGait) {
                        ForEach(gaits, id: \.self) { gait in
                            Text(gait).tag(gait)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 150)
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)

                // Description
                if let description = gaitDescriptions[selectedGait] {
                    VStack(spacing: 10) {
                        HStack {
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                            Text("About \(selectedGait)")
                                .font(.headline)
                            Spacer()
                        }

                        Text(description)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(12)
                }

                // Apply Button
                Button(action: applyGait) {
                    if isApplying {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Apply Gait")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(isApplying || !api.isPowered)

                if !api.isPowered {
                    Text("Power on Spot to change gait")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()
            }
            .padding()
        }
    }

    private func applyGait() {
        isApplying = true
        api.setGait(selectedGait.lowercased()) { success in
            isApplying = false
            if success {
                print("Gait changed to \(selectedGait)")
            }
        }
    }
}

#Preview {
    GaitSelectionView(api: SpotAPI())
}
