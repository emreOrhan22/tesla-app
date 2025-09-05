//
//  LockScreenView.swift
//  tesla app
//
//  Created by Emre ORHAN on 3.09.2025.
//

import SwiftUI

struct LockScreenView: View {
    @ObservedObject var viewModel: TeslaAppViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.black.ignoresSafeArea()
            
            if viewModel.car.isLocked {
                CenteredCarView(carImageName: "lock_car")
                    .padding(.horizontal, 24)
            } else {
                UnlockedPanelView(carImageName: "unlock_car")
                    .ignoresSafeArea(edges: .bottom)
            }

            // Simple SF Symbol gear button in the corner
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

            // Bottom unlock control pinned to bottom center
            VStack {
                Spacer()
                UnlockControl(isLocked: viewModel.car.isLocked) {
                    viewModel.toggleLock()
                    if !viewModel.car.isLocked {
                        withAnimation(.easeInOut(duration: 0.35)) {
                            viewModel.currentScreen = .lockUnlocked
                        }
                    }
                }
                .padding(.bottom, 78)
            }
        }
    }
}

// MARK: - Unlock Control
private struct UnlockControl: View {
    let isLocked: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Text(isLocked ? "Unlock" : "Lock")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white.opacity(0.9))
                
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue.opacity(0.9), Color.cyan.opacity(0.9)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 36, height: 36)
                        .shadow(color: .cyan.opacity(0.4), radius: 10, x: 0, y: 0)
                    Image(systemName: isLocked ? "lock.fill" : "lock.open.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 14, weight: .bold))
                }
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 16)
            .background(
                Capsule()
                    .fill(Color(red: 0.14, green: 0.14, blue: 0.14))
                    .shadow(color: .white.opacity(0.06), radius: 8, x: -3, y: -3)
                    .shadow(color: .black.opacity(0.85), radius: 12, x: 4, y: 6)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(isLocked ? "Unlock car" : "Lock car")
    }
}

#Preview {
    LockScreenView(viewModel: TeslaAppViewModel())
        .background(Color.black)
}

// MARK: - Centered Car View
struct CenteredCarView: View {
    let carImageName: String
    private let carMaxWidth: CGFloat = 360
    private let carDesiredHeight: CGFloat = 260
    
    var body: some View {
        VStack {
            Spacer()
            Image(carImageName)
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: carMaxWidth)
                .frame(height: carDesiredHeight)
            Spacer()
        }
    }
}

// MARK: - Unlocked Panel View (rounded panel + centered car)
struct UnlockedPanelView: View {
    let carImageName: String
    private let cornerRadius: CGFloat = 28
    private let carMaxWidth: CGFloat = 360
    private let carDesiredHeight: CGFloat = 260
    
    var body: some View {
        GeometryReader { geo in
            let bottomSpace: CGFloat = 140 // leave space for unlock button
            VStack {
                Spacer(minLength: 0)
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.12, green: 0.15, blue: 0.18),
                                Color(red: 0.08, green: 0.09, blue: 0.11)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(Color.white.opacity(0.06), lineWidth: 0.5)
                    )
                    .shadow(color: .black.opacity(0.5), radius: 24, x: 0, y: 10)
                    .frame(maxWidth: .infinity, maxHeight: geo.size.height - bottomSpace)
                    .padding(.horizontal, 20)
                    .overlay(
                        VStack {
                            Spacer().frame(height: 28)
                            Image(carImageName)
                                .renderingMode(.original)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: carMaxWidth)
                                .frame(height: carDesiredHeight)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, bottomSpace)
                    )
                Spacer(minLength: 0)
            }
        }
    }
}

// MARK: - Top Panel
private struct LockTopPanel: View {
    let carImageName: String
    let settingsAction: () -> Void
    
    // Tunable layout constants to match Figma
    private let cornerRadius: CGFloat = 28
    private let panelHeight: CGFloat = 520
    private let panelHorizontalPadding: CGFloat = 24
    private let settingsSize: CGFloat = 52
    private let carHeight: CGFloat = 260 // image's visual height inside panel
    private let carTopInset: CGFloat = 110 // distance from panel top to car image top
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Fully black screen look: no panel fill, no extra glow
            Color.clear
            
            // Simple SF Symbol gear button in the corner
            Button(action: settingsAction) {
                Image(systemName: "gearshape.fill")
                    .foregroundColor(.white.opacity(0.9))
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: settingsSize, height: settingsSize)
                    .background(
                        Circle().fill(Color.white.opacity(0.06))
                    )
                    .overlay(
                        Circle().stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )
            }
            .padding(.top, 22)
            .padding(.trailing, 22)
            
            // Car image centered with fixed size (no extra glow)
            VStack(spacing: 0) {
                Spacer().frame(height: carTopInset)
                ZStack {
                    Image(carImageName)
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(height: carHeight)
                }
                Spacer()
            }
            .padding(.horizontal, panelHorizontalPadding)
        }
        .frame(maxWidth: .infinity)
        .frame(height: panelHeight)
        .padding(.horizontal, panelHorizontalPadding)
    }
}
