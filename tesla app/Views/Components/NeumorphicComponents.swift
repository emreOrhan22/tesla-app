//
//  NeumorphicComponents.swift
//  tesla app
//
//  Created by Emre ORHAN on 3.09.2025.
//

import SwiftUI

// MARK: - Neumorphic Card
struct NeumorphicCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(red: 0.15, green: 0.15, blue: 0.15))
                    .shadow(color: Color.white.opacity(0.1), radius: 8, x: -4, y: -4)
                    .shadow(color: Color.black.opacity(0.8), radius: 8, x: 4, y: 4)
            )
    }
}

// MARK: - Simple Haptic helper
enum Haptic {
    static func light() {
        #if os(iOS)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        #endif
    }
}

// MARK: - Unlock Capsule Button (asset-driven)
struct UnlockCapsuleButton: View {
    // Asset names (provide your own in Assets). If an asset is missing, SwiftUI fallback styles are used.
    let idleBackground: String       // e.g., "unlock_bg"
    let pressedBackground: String?   // e.g., "unlock_bg_pressed" (optional)
    let rightGlow: String?           // e.g., "unlock_glow" (optional)
    let lockedIcon: String?          // e.g., PNG for lock; if nil, uses SF Symbol
    let unlockedIcon: String?        // e.g., PNG for unlock; if nil, uses SF Symbol
    
    @Binding var isLocked: Bool
    let titleLocked: String
    let titleUnlocked: String
    let action: () -> Void
    
    @State private var isPressed: Bool = false
    
    var body: some View {
        Button(action: {
            Haptic.light()
            action()
        }) {
            ZStack {
                // Background (asset or fallback capsule)
                if let pressed = pressedBackground, isPressed, UIImage(named: pressed) != nil {
                    Image(pressed)
                        .resizable()
                        .scaledToFit()
                } else if UIImage(named: idleBackground) != nil {
                    Image(idleBackground)
                        .resizable()
                        .scaledToFit()
                } else {
                    Capsule()
                        .fill(Color(red: 0.14, green: 0.14, blue: 0.14))
                        .shadow(color: .white.opacity(0.06), radius: 8, x: -3, y: -3)
                        .shadow(color: .black.opacity(0.85), radius: 12, x: 4, y: 6)
                }
                
                // Content
                HStack(spacing: 14) {
                    Text(isLocked ? titleLocked : titleUnlocked)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.leading, 22)
                        .padding(.vertical, 12)
                    Spacer(minLength: 16)
                    ZStack {
                        if let glow = rightGlow, UIImage(named: glow) != nil {
                            Image(glow)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 42, height: 42)
                                .opacity(isPressed ? 0.9 : 1.0)
                        } else {
                            Circle()
                                .fill(
                                    LinearGradient(gradient: Gradient(colors: [Color.blue, Color.cyan]), startPoint: .top, endPoint: .bottom)
                                )
                                .frame(width: 40, height: 40)
                                .shadow(color: .cyan.opacity(0.5), radius: 10)
                        }
                        if isLocked {
                            if let lock = lockedIcon, UIImage(named: lock) != nil {
                                Image(lock).resizable().scaledToFit().frame(width: 16, height: 16)
                            } else {
                                Image(systemName: "lock.fill").foregroundColor(.white).font(.system(size: 14, weight: .bold))
                            }
                        } else {
                            if let unlock = unlockedIcon, UIImage(named: unlock) != nil {
                                Image(unlock).resizable().scaledToFit().frame(width: 18, height: 18)
                            } else {
                                Image(systemName: "lock.open.fill").foregroundColor(.white).font(.system(size: 14, weight: .bold))
                            }
                        }
                    }
                    .padding(.trailing, 16)
                }
                .padding(.horizontal, 8)
            }
            .frame(height: 60)
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0)
                .onChanged { _ in withAnimation(.easeInOut(duration: 0.1)) { isPressed = true } }
                .onEnded { _ in withAnimation(.easeOut(duration: 0.18)) { isPressed = false } }
        )
        .accessibilityLabel(isLocked ? "Unlock" : "Lock")
    }
}

// MARK: - Neumorphic Button
struct NeumorphicButton: View {
    let icon: String
    @Binding var isPressed: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(Color(red: 0.15, green: 0.15, blue: 0.15))
                        .shadow(color: Color.white.opacity(0.1), radius: isPressed ? 2 : 4, x: isPressed ? -1 : -2, y: isPressed ? -1 : -2)
                        .shadow(color: Color.black.opacity(0.8), radius: isPressed ? 2 : 4, x: isPressed ? 1 : 2, y: isPressed ? 1 : 2)
                )
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

// MARK: - Quick Access Button
struct QuickAccessButton: View {
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(Color(red: 0.15, green: 0.15, blue: 0.15))
                        .shadow(color: Color.white.opacity(0.1), radius: 4, x: -2, y: -2)
                        .shadow(color: Color.black.opacity(0.8), radius: 4, x: 2, y: 2)
                )
        }
    }
}

// MARK: - Control Slider
struct ControlSlider: View {
    let title: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 60, alignment: .leading)
            
            Slider(value: Binding(
                get: { Double(value) },
                set: { value = Int($0) }
            ), in: Double(range.lowerBound)...Double(range.upperBound), step: 1)
            .accentColor(.blue)
        }
    }
}

// MARK: - Neumorphic Toggle Style
struct NeumorphicToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            RoundedRectangle(cornerRadius: 16)
                .fill(configuration.isOn ? Color.blue : Color(red: 0.15, green: 0.15, blue: 0.15))
                .frame(width: 50, height: 30)
                .overlay(
                    Circle()
                        .fill(Color.white)
                        .frame(width: 26, height: 26)
                        .offset(x: configuration.isOn ? 10 : -10)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isOn)
                )
                .shadow(color: Color.white.opacity(0.1), radius: 4, x: -2, y: -2)
                .shadow(color: Color.black.opacity(0.8), radius: 4, x: 2, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Supercharger Row
struct SuperchargerRow: View {
    let supercharger: SuperchargerLocation
    
    var body: some View {
        HStack {
            Image(systemName: "location.fill")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(supercharger.name)
                    .font(.subheadline)
                    .foregroundColor(.white)
                Text(supercharger.distance)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if supercharger.isAvailable {
                Text("Available")
                    .font(.caption)
                    .foregroundColor(.green)
            } else {
                Text("Busy")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Temperature Dial
struct TemperatureDial: View {
    let temperature: Int
    
    var body: some View {
        ZStack {
            // Outer ring
            Circle()
                .stroke(Color(red: 0.15, green: 0.15, blue: 0.15), lineWidth: 8)
                .frame(width: 200, height: 200)
                .shadow(color: Color.white.opacity(0.1), radius: 8, x: -4, y: -4)
                .shadow(color: Color.black.opacity(0.8), radius: 8, x: 4, y: 4)
            
            // Temperature ring
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [.blue, .cyan]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .frame(width: 200, height: 200)
                .rotationEffect(.degrees(-90))
            
            // Temperature display
            Text("\(temperature)")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.white)
        }
    }
}

// MARK: - Battery Progress Bar
struct BatteryProgressBar: View {
    let progress: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background track
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(red: 0.15, green: 0.15, blue: 0.15))
                    .frame(height: 12)
                
                // Progress fill
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .cyan]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * progress, height: 12)
            }
        }
        .frame(height: 12)
    }
}
