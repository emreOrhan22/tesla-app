//
//  TeslaModels.swift
//  tesla app
//
//  Created by Emre ORHAN on 3.09.2025.
//

import Foundation

// MARK: - Car Model
struct TeslaCar {
    let model: String
    let variant: String
    var batteryLevel: Int
    var range: Int
    var isLocked: Bool
    var temperature: Int
}

// MARK: - Climate Settings
struct ClimateSettings {
    var temperature: Int
    var fanSpeed: Int
    var airFlow: Int
    var heatLevel: Int
    var autoMode: Bool
    var isOn: Bool
}

// MARK: - Charging Settings
struct ChargingSettings {
    var batteryLevel: Int
    var chargeLimit: Int
    var isCharging: Bool
    var chargingSpeed: String
}

// MARK: - Supercharger Location
struct SuperchargerLocation {
    let name: String
    let distance: String
    let isAvailable: Bool
    let chargingSpeed: String
}

// MARK: - App State
enum AppScreen {
    case splash
    case lock
    case lockUnlocked
    case home
    case climate
    case charging
}
