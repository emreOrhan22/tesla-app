//
//  ChargingScreenView.swift
//  tesla app
//
//  Created by Emre ORHAN on 3.09.2025.
//

import SwiftUI

struct ChargingScreenView: View {
    @ObservedObject var viewModel: TeslaAppViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            // Header
            HStack {
                Button(action: {
                    viewModel.navigateBack()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text("CHARGING")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Color.clear
                    .frame(width: 20, height: 20)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            // Car and Battery
            VStack(spacing: 20) {
                // Car side view
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(red: 0.15, green: 0.15, blue: 0.15))
                        .frame(width: 200, height: 80)
                        .shadow(color: Color.white.opacity(0.1), radius: 8, x: -4, y: -4)
                        .shadow(color: Color.black.opacity(0.8), radius: 8, x: 4, y: 4)
                    
                    // Car side representation
                    VStack {
                        Rectangle()
                            .fill(Color.white.opacity(0.3))
                            .frame(width: 160, height: 6)
                            .cornerRadius(3)
                        
                        Rectangle()
                            .fill(Color.white.opacity(0.3))
                            .frame(width: 140, height: 4)
                            .cornerRadius(2)
                    }
                }
                
                Text("\(viewModel.chargingSettings.batteryLevel)%")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                
                // Battery progress bar
                BatteryProgressBar(progress: Double(viewModel.chargingSettings.batteryLevel) / 100.0)
                    .padding(.horizontal, 20)
            }
            
            // Charge Limit Slider
            VStack(spacing: 16) {
                HStack {
                    Text("Set Charge Limit")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                    Text("\(viewModel.chargingSettings.chargeLimit)%")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                
                Slider(value: Binding(
                    get: { Double(viewModel.chargingSettings.chargeLimit) },
                    set: { viewModel.updateChargeLimit(Int($0)) }
                ), in: 0...100, step: 1)
                .accentColor(.blue)
            }
            .padding(.horizontal, 20)
            
            // Superchargers Section
            VStack(spacing: 16) {
                Button(action: {
                    viewModel.toggleSuperchargers()
                }) {
                    HStack {
                        Text("Nearby Superchargers")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Image(systemName: viewModel.showSuperchargers ? "chevron.up" : "chevron.down")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                if viewModel.showSuperchargers {
                    VStack(spacing: 12) {
                        ForEach(viewModel.superchargerLocations.indices, id: \.self) { index in
                            SuperchargerRow(supercharger: viewModel.superchargerLocations[index])
                        }
                    }
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity),
                        removal: .scale.combined(with: .opacity)
                    ))
                }
            }
            .padding(.horizontal, 20)
            
            // Quick Access Icons
            HStack(spacing: 40) {
                QuickAccessButton(icon: "car.fill", action: {})
                QuickAccessButton(icon: "bolt.fill", action: {})
                QuickAccessButton(icon: "person.fill", action: {})
                QuickAccessButton(icon: "gear", action: {})
            }
            
            Spacer()
        }
    }
}

#Preview {
    ChargingScreenView(viewModel: TeslaAppViewModel())
        .background(Color(red: 0.1, green: 0.1, blue: 0.1))
}
