//
//  API.swift
//  SpotController
//
//  Created on 2026-02-08.
//

import Foundation
import SwiftUI

// Response structure for API calls
struct APIResponse: Codable {
    let status: String?
    let message: String?
    let success: Bool?
}

// Main API class for communicating with the FastAPI backend
class SpotAPI: ObservableObject {
    @Published var baseURL: String = "http://localhost:8081"
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String = ""
    @Published var isPowered: Bool = false
    @Published var isStanding: Bool = false

    // MARK: - Connection Management

    func connect(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/connect") else {
            errorMessage = "Invalid URL"
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = "Connection error: \(error.localizedDescription)"
                    completion(false)
                    return
                }

                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    self?.isAuthenticated = true
                    self?.errorMessage = ""
                    completion(true)
                } else {
                    self?.errorMessage = "Failed to connect to Spot"
                    completion(false)
                }
            }
        }.resume()
    }

    func disconnect(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/disconnect") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        URLSession.shared.dataTask(with: request) { [weak self] _, response, _ in
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    self?.isAuthenticated = false
                    self?.isPowered = false
                    self?.isStanding = false
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }.resume()
    }

    // MARK: - Power Management

    func powerOn(completion: @escaping (Bool) -> Void) {
        sendCommand(endpoint: "/api/power/on") { [weak self] success in
            if success {
                self?.isPowered = true
            }
            completion(success)
        }
    }

    func powerOff(completion: @escaping (Bool) -> Void) {
        sendCommand(endpoint: "/api/power/off") { [weak self] success in
            if success {
                self?.isPowered = false
                self?.isStanding = false
            }
            completion(success)
        }
    }

    // MARK: - Stance Control

    func stand(completion: @escaping (Bool) -> Void) {
        sendCommand(endpoint: "/api/stand") { [weak self] success in
            if success {
                self?.isStanding = true
            }
            completion(success)
        }
    }

    func sit(completion: @escaping (Bool) -> Void) {
        sendCommand(endpoint: "/api/sit") { [weak self] success in
            if success {
                self?.isStanding = false
            }
            completion(success)
        }
    }

    // MARK: - Emergency Stop

    func eStop(completion: @escaping (Bool) -> Void) {
        sendCommand(endpoint: "/api/estop") { success in
            completion(success)
        }
    }

    func releaseEStop(completion: @escaping (Bool) -> Void) {
        sendCommand(endpoint: "/api/estop/release") { success in
            completion(success)
        }
    }

    // MARK: - Movement Commands

    func move(direction: String, completion: @escaping (Bool) -> Void) {
        sendCommand(endpoint: "/api/move/\(direction)") { success in
            completion(success)
        }
    }

    // MARK: - Gait Selection

    func setGait(_ gait: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/gait") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["gait": gait]
        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { _, response, _ in
            DispatchQueue.main.async {
                completion((response as? HTTPURLResponse)?.statusCode == 200)
            }
        }.resume()
    }

    // MARK: - Animation Control

    func playAnimation(_ animation: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/animation/\(animation)") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        URLSession.shared.dataTask(with: request) { _, response, _ in
            DispatchQueue.main.async {
                completion((response as? HTTPURLResponse)?.statusCode == 200)
            }
        }.resume()
    }

    // MARK: - Pose Control

    func setPose(yaw: Double, roll: Double, pitch: Double, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/pose") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["yaw": yaw, "roll": roll, "pitch": pitch]
        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { _, response, _ in
            DispatchQueue.main.async {
                completion((response as? HTTPURLResponse)?.statusCode == 200)
            }
        }.resume()
    }

    // MARK: - Helper Methods

    private func sendCommand(endpoint: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(false)
                    return
                }

                let success = (response as? HTTPURLResponse)?.statusCode == 200
                completion(success)
            }
        }.resume()
    }
}
