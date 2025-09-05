//
//  HomeScreenView.swift
//  tesla app
//
//  Created by Emre ORHAN on 3.09.2025.
//

import SwiftUI

struct HomeScreenView: View {
    @ObservedObject var viewModel: TeslaAppViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            // Header
            VStack(spacing: 8) {
                Text("Tesla")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("\(viewModel.car.batteryLevel) / \(viewModel.car.range) km")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
            }
            .padding(.top, 20)
            
            // Car Model
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(red: 0.15, green: 0.15, blue: 0.15))
                    .frame(width: 250, height: 120)
                    .shadow(color: Color.white.opacity(0.1), radius: 8, x: -4, y: -4)
                    .shadow(color: Color.black.opacity(0.8), radius: 8, x: 4, y: 4)
                
                // Tesla Model S Plaid representation
                VStack(spacing: 8) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.6))
                        .frame(width: 180, height: 6)
                        .cornerRadius(3)
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.6))
                        .frame(width: 200, height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.6))
                        .frame(width: 160, height: 6)
                        .cornerRadius(3)
                }
            }
            
            // Control Card
            NeumorphicCard {
                VStack(spacing: 16) {
                    HStack {
                        Text("Control")
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    
                    Button(action: {
                        viewModel.navigateToClimate()
                    }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Climate Interior")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                Text("\(viewModel.car.temperature)°C")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.white)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(20)
            }
            .padding(.horizontal, 20)
            
            // Quick Access Icons
            HStack(spacing: 40) {
                QuickAccessButton(icon: "car.fill", action: {})
                QuickAccessButton(icon: "bolt.fill", action: {
                    viewModel.navigateToCharging()
                })
                QuickAccessButton(icon: "person.fill", action: {})
                QuickAccessButton(icon: "gear", action: {})
            }
            
            Spacer()
        }
    }
}

#Preview {
    HomeScreenView(viewModel: TeslaAppViewModel())
        .background(Color(red: 0.1, green: 0.1, blue: 0.1))
}
