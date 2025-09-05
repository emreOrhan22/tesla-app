//
//  ClimateScreenView.swift
//  tesla app
//
//  Created by Emre ORHAN on 3.09.2025.
//

import SwiftUI

struct ClimateScreenView: View {
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
                
                Text("CLIMATE")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                // Placeholder for symmetry
                Color.clear
                    .frame(width: 20, height: 20)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            // Temperature Dial
            VStack(spacing: 20) {
                TemperatureDial(temperature: viewModel.climateSettings.temperature)
                
                Text("\(viewModel.climateSettings.temperature)°")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
            }
            
            // Control Sliders
            VStack(spacing: 20) {
                ControlSlider(
                    title: "Air",
                    value: Binding(
                        get: { viewModel.climateSettings.airFlow },
                        set: { viewModel.updateAirFlow($0) }
                    ),
                    range: 0...5
                )
                
                ControlSlider(
                    title: "Fan",
                    value: Binding(
                        get: { viewModel.climateSettings.fanSpeed },
                        set: { viewModel.updateFanSpeed($0) }
                    ),
                    range: 0...5
                )
                
                ControlSlider(
                    title: "Heat",
                    value: Binding(
                        get: { viewModel.climateSettings.heatLevel },
                        set: { viewModel.updateHeatLevel($0) }
                    ),
                    range: 0...5
                )
            }
            .padding(.horizontal, 20)
            
            // Auto Toggle
            HStack {
                Text("Auto")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Toggle("", isOn: Binding(
                    get: { viewModel.climateSettings.autoMode },
                    set: { _ in viewModel.toggleAutoMode() }
                ))
                .toggleStyle(NeumorphicToggleStyle())
            }
            .padding(.horizontal, 20)
            
            // Bottom Controls
            HStack(spacing: 40) {
                Button(action: {
                    viewModel.toggleClimate()
                }) {
                    Image(systemName: "power")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(viewModel.climateSettings.isOn ? .green : .white)
                }
                
                Button(action: {}) {
                    Image(systemName: "thermometer")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.white)
                }
                
                Button(action: {}) {
                    Image(systemName: "seat")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.white)
                }
            }
            .padding(.bottom, 30)
            
            Spacer()
        }
    }
}

#Preview {
    ClimateScreenView(viewModel: TeslaAppViewModel())
        .background(Color(red: 0.1, green: 0.1, blue: 0.1))
}
