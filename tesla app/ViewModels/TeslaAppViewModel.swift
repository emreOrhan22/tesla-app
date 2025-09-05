//
//  TeslaAppViewModel.swift
//  tesla app
//
//  Created by Emre ORHAN on 3.09.2025.
//

import Foundation
import SwiftUI

@MainActor
class TeslaAppViewModel: ObservableObject {
    @Published var currentScreen: AppScreen = .splash
    @Published var car: TeslaCar
    @Published var climateSettings: ClimateSettings
    @Published var chargingSettings: ChargingSettings
    @Published var superchargerLocations: [SuperchargerLocation]
    @Published var showSuperchargers: Bool = false
    
    init() {
        // Initialize with default values
        self.car = TeslaCar(
            model: "Model 3",
            variant: "Plaid",
            batteryLevel: 65,
            range: 137,
            isLocked: true,
            temperature: 20
        )
        
        self.climateSettings = ClimateSettings(
            temperature: 20,
            fanSpeed: 3,
            airFlow: 2,
            heatLevel: 1,
            autoMode: true,
            isOn: false
        )
        
        self.chargingSettings = ChargingSettings(
            batteryLevel: 65,
            chargeLimit: 80,
            isCharging: false,
            chargingSpeed: "Standard"
        )
        
        self.superchargerLocations = [
            SuperchargerLocation(
                name: "Tesla Supercharger - Montreal, QC",
                distance: "1.7 km",
                isAvailable: true,
                chargingSpeed: "250 kW"
            ),
            SuperchargerLocation(
                name: "Tesla Supercharger - 2nd location",
                distance: "3.2 km",
                isAvailable: true,
                chargingSpeed: "150 kW"
            )
        ]
    }
    
    // MARK: - Navigation Methods
    func navigateToLock() {
        withAnimation(.easeInOut(duration: 0.5)) {
            currentScreen = .lock
        }
    }
    
    func navigateToHome() {
        withAnimation(.easeInOut(duration: 0.5)) {
            currentScreen = .home
        }
    }
    
    func navigateToClimate() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentScreen = .climate
        }
    }
    
    func navigateToCharging() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentScreen = .charging
        }
    }
    
    func navigateBack() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentScreen = .home
        }
    }
    
    // MARK: - Car Control Methods
    func toggleLock() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            car.isLocked.toggle()
        }
        // Stay on the same screen; UI will update to locked/unlocked variant
    }
    
    // MARK: - Climate Control Methods
    func updateTemperature(_ newTemperature: Int) {
        climateSettings.temperature = max(16, min(30, newTemperature))
        car.temperature = climateSettings.temperature
    }
    
    func updateFanSpeed(_ newSpeed: Int) {
        climateSettings.fanSpeed = max(0, min(5, newSpeed))
    }
    
    func updateAirFlow(_ newFlow: Int) {
        climateSettings.airFlow = max(0, min(5, newFlow))
    }
    
    func updateHeatLevel(_ newLevel: Int) {
        climateSettings.heatLevel = max(0, min(5, newLevel))
    }
    
    func toggleAutoMode() {
        climateSettings.autoMode.toggle()
    }
    
    func toggleClimate() {
        climateSettings.isOn.toggle()
    }
    
    // MARK: - Charging Control Methods
    func updateChargeLimit(_ newLimit: Int) {
        chargingSettings.chargeLimit = max(0, min(100, newLimit))
    }
    
    func toggleSuperchargers() {
        withAnimation(.easeInOut(duration: 0.3)) {
            showSuperchargers.toggle()
        }
    }
    
    // MARK: - Battery Management
    func updateBatteryLevel(_ newLevel: Int) {
        car.batteryLevel = max(0, min(100, newLevel))
        chargingSettings.batteryLevel = car.batteryLevel
    }
}
