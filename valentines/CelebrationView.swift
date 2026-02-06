import SwiftUI
import UIKit

struct HeartParticle: Identifiable {
    let id = UUID()
    let x: CGFloat
    let y: CGFloat
    let scale: CGFloat
    let rotation: Double
    let opacity: Double
    let delay: Double
    let fontSize: CGFloat
}

struct CelebrationView: View {
    @State private var heartScale: CGFloat = 0.1
    @State private var showYay: Bool = false
    @State private var showMessage: Bool = false
    @State private var showHappyValentines: Bool = false
    @State private var heartRowVisible: [Bool] = Array(repeating: false, count: 5)
    @State private var yayOffset: CGFloat = 30
    @State private var heartParticles: [HeartParticle] = CelebrationView.generateHeartParticles()
    @State private var showHeartBurst: Bool = false
    @State private var heartBurstFading: Bool = false

    var body: some View {
        ZStack {
            Theme.celebrationGradient
                .ignoresSafeArea()

            FloatingHeartsView(count: 30)
                .ignoresSafeArea()

            // Red hearts burst layer
            GeometryReader { geo in
                ForEach(heartParticles) { particle in
                    Text("❤️")
                        .font(.system(size: particle.fontSize))
                        .scaleEffect(showHeartBurst ? particle.scale : 0)
                        .rotationEffect(.degrees(showHeartBurst ? particle.rotation : 0))
                        .opacity(heartBurstFading ? 0 : (showHeartBurst ? particle.opacity : 0))
                        .position(
                            x: heartBurstFading
                                ? (0.5 + (particle.x - 0.5) * 2.5) * geo.size.width
                                : (showHeartBurst ? particle.x * geo.size.width : geo.size.width / 2),
                            y: heartBurstFading
                                ? (0.5 + (particle.y - 0.5) * 2.5) * geo.size.height
                                : (showHeartBurst ? particle.y * geo.size.height : geo.size.height / 2)
                        )
                        .animation(
                            .spring(response: 0.6, dampingFraction: 0.6)
                            .delay(particle.delay),
                            value: showHeartBurst
                        )
                        .animation(
                            .easeOut(duration: 0.8),
                            value: heartBurstFading
                        )
                }
            }
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Text("💕")
                    .font(.system(size: 100))
                    .scaleEffect(heartScale)

                if showYay {
                    Text("YAAAY! 🎉")
                        .font(.system(size: 42, weight: .heavy, design: .rounded))
                        .foregroundStyle(Theme.deepRose)
                        .offset(y: yayOffset)
                        .transition(.opacity)
                }

                if showMessage {
                    Text("heheh I knew you'd say yes 🥰")
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                        .foregroundStyle(Theme.romanticPurple.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .transition(.opacity.combined(with: .scale(scale: 0.8)))
                }

                if showHappyValentines {
                    Text("i miss you so much bao bao")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(Theme.celebrationTextGradient)
                        .multilineTextAlignment(.center)
                        .transition(.opacity.combined(with: .scale(scale: 0.8)))
                    Text("have a great day")
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                        .foregroundStyle(Theme.celebrationTextGradient)
                        .multilineTextAlignment(.center)
                }

                HStack(spacing: 16) {
                    ForEach(0..<5, id: \.self) { index in
                        if heartRowVisible[index] {
                            Text(heartEmoji(for: index))
                                .font(.system(size: 36))
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                }
                .frame(height: 50)

                Spacer()
                Spacer()
            }
            .padding()
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.5)) {
                heartScale = 1.0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                showHeartBurst = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                heartBurstFading = true
            }

            withAnimation(.easeOut(duration: 0.5).delay(0.4)) {
                showYay = true
                yayOffset = 0
            }

            withAnimation(.easeOut(duration: 0.5).delay(0.9)) {
                showMessage = true
            }

            withAnimation(.easeOut(duration: 0.5).delay(1.4)) {
                showHappyValentines = true
            }

            for i in 0..<5 {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6).delay(1.8 + Double(i) * 0.15)) {
                    heartRowVisible[i] = true
                }
            }

            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }

    private func heartEmoji(for index: Int) -> String {
        let hearts = ["💕", "💗", "💜", "💖", "💝"]
        return hearts[index]
    }

    static func generateHeartParticles() -> [HeartParticle] {
        (0..<50).map { _ in
            HeartParticle(
                x: CGFloat.random(in: 0.05...0.95),
                y: CGFloat.random(in: 0.05...0.95),
                scale: CGFloat.random(in: 0.6...1.2),
                rotation: Double.random(in: -30...30),
                opacity: Double.random(in: 0.6...1.0),
                delay: Double.random(in: 0...0.1),
                fontSize: CGFloat.random(in: 20...44)
            )
        }
    }
}

#Preview {
    CelebrationView()
}
