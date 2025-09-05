//
//  ContentView.swift
//  tesla app
//
//  Created by Emre ORHAN on 3.09.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TeslaAppViewModel()
    
    var body: some View {
        ZStack {
            // Dark background
            Color(red: 0.1, green: 0.1, blue: 0.1)
                .ignoresSafeArea()
            
            switch viewModel.currentScreen {
            case .splash:
                SplashScreenView(viewModel: viewModel)
            case .lock:
                LockScreenView(viewModel: viewModel)
            case .lockUnlocked:
                LockUnlockedScreenView(viewModel: viewModel)
            case .home:
                HomeScreenView(viewModel: viewModel)
            case .climate:
                ClimateScreenView(viewModel: viewModel)
            case .charging:
                ChargingScreenView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    ContentView()
}
