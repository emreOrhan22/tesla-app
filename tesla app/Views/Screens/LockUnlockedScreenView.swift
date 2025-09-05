//
//  LockUnlockedScreenView.swift
//  tesla app
//
//  Created by Emre ORHAN on 3.09.2025.
//

import SwiftUI

struct LockUnlockedScreenView: View {
    @ObservedObject var viewModel: TeslaAppViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.black.ignoresSafeArea()
            
            UnlockedPanelView(carImageName: "unlock_car")
                .ignoresSafeArea(edges: .bottom)
            
            // gear
            HStack {
                Spacer()
                Button(action: {}) {
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(.white.opacity(0.9))
                        .font(.system(size: 18, weight: .semibold))
                        .frame(width: 52, height: 52)
                        .background(Circle().fill(Color.white.opacity(0.06)))
                        .overlay(Circle().stroke(Color.white.opacity(0.08), lineWidth: 1))
                }
                .padding(.trailing, 22)
                .padding(.top, 22)
            }
            
            VStack {
                Spacer()
                UnlockControl(isLocked: viewModel.car.isLocked) {
                    withAnimation(.easeInOut(duration: 0.35)) {
                        viewModel.toggleLock()
                        viewModel.currentScreen = .lock
                    }
                }
                .padding(.bottom, 78)
            }
        }
        .transition(.opacity.combined(with: .move(edge: .bottom)))
    }
}


