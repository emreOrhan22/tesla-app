//
//  SplashScreenView.swift
//  tesla app
//
//  Created by Emre ORHAN on 3.09.2025.
//

import SwiftUI

struct SplashScreenView: View {
    @ObservedObject var viewModel: TeslaAppViewModel
    @State private var logoOpacity: Double = 0.0
    @State private var logoScale: Double = 0.95
    
    var body: some View {
        ZStack {
            // Black background
            Color.black
                .ignoresSafeArea()
            
            // Emitting rings behind the logo for subtle loading feel
            ZStack {
                EmittingRing(maxScale: 1.6, initialOpacity: 0.18, duration: 2.0, delay: 0.0)
                EmittingRing(maxScale: 1.7, initialOpacity: 0.16, duration: 2.2, delay: 0.6)
            }
            .frame(width: 280, height: 280)
            
            // Tesla Logo
            TeslaLogoView()
                .opacity(logoOpacity)
                .scaleEffect(logoScale)
        }
        .onAppear {
            startAnimation()
        }
    }
    
    private func startAnimation() {
        // First: Logo appears and scales up
        withAnimation(.easeOut(duration: 0.9)) {
            logoOpacity = 1.0
            logoScale = 1.0
        }
        
        // Third: Navigate to lock screen after animation completes
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation(.easeInOut(duration: 0.5)) {
                viewModel.navigateToLock()
            }
        }
    }
}

// MARK: - Tesla Logo Component
struct TeslaLogoView: View {
    @State private var glowUp: Bool = false
    @State private var sweepProgress: CGFloat = -1.0
    
    var body: some View {
        ZStack {
            // Base logo
            Image("tesla_logo")
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 160, height: 160)
                .foregroundColor(.white)
            
            // Soft glow pulse
            Image("tesla_logo")
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 160, height: 160)
                .foregroundColor(.white)
                .blur(radius: 16)
                .opacity(glowUp ? 0.45 : 0.18)
                .scaleEffect(glowUp ? 1.03 : 0.98)
                .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: glowUp)
            
            // Specular sweep masked by logo
            sweepHighlight
                .frame(width: 300, height: 300)
                .mask(
                    Image("tesla_logo")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 160, height: 160)
                )
                .allowsHitTesting(false)
        }
        .onAppear {
            glowUp.toggle()
            withAnimation(.linear(duration: 1.4).repeatForever(autoreverses: false)) {
                sweepProgress = 1.2
            }
        }
    }
    
    private var sweepHighlight: some View {
        // A diagonal moving white band that sweeps across the masked logo
        LinearGradient(
            gradient: Gradient(colors: [
                .white.opacity(0.0),
                .white.opacity(0.85),
                .white.opacity(0.0)
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
        .rotationEffect(.degrees(24))
        .offset(x: sweepProgress * 220)
        .blendMode(.screen)
        .opacity(0.6)
    }
}

// MARK: - Emitting Ring
struct EmittingRing: View {
    let maxScale: CGFloat
    let initialOpacity: Double
    let duration: Double
    let delay: Double
    
    @State private var animate: Bool = false
    
    var body: some View {
        RadialGradient(
            gradient: Gradient(stops: [
                .init(color: .white.opacity(initialOpacity), location: 0.0),
                .init(color: .white.opacity(0.0), location: 1.0)
            ]),
            center: .center,
            startRadius: 1,
            endRadius: 120
        )
        .opacity(animate ? 0.0 : initialOpacity)
        .scaleEffect(animate ? maxScale : 1.0)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeOut(duration: duration).repeatForever(autoreverses: false)) {
                    animate = true
                }
            }
        }
    }
}

#Preview {
    SplashScreenView(viewModel: TeslaAppViewModel())
}
