import SwiftUI
import UIKit

struct ContentView: View {
    @State private var rejectionCount = 0
    @State private var noButtonState = NoButtonState()
    @State private var rejectionText: String = ""
    @State private var showCelebration = false
    @State private var messageOpacity: Double = 0.0
    @State private var pulseScale: CGFloat = 1.0

    private var yesScale: CGFloat {
        min(1.0 + CGFloat(rejectionCount) * 0.12, 2.5)
    }

    private var yesFontSize: CGFloat {
        20 + CGFloat(rejectionCount)
    }

    private var yesHPadding: CGFloat {
        40 + CGFloat(rejectionCount) * 3
    }

    private var noFontSize: CGFloat {
        max(20 - CGFloat(rejectionCount) * 0.5, 10)
    }

    private var noText: String {
        rejectionCount >= 15 ? "no" : "No"
    }

    var body: some View {
        if showCelebration {
            CelebrationView()
                .transition(.opacity)
        } else {
            questionView
        }
    }

    private var questionView: some View {
        GeometryReader { geometry in
            ZStack {
                Theme.backgroundGradient
                    .ignoresSafeArea()

                FloatingHeartsView(count: 15)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Spacer()

                    Text("💗💕💜")
                        .font(.system(size: 40))

                    Text("Hi Tessa, will you be my Valentine? 💕")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary.opacity(0.85))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)

                    if rejectionCount > 0 {
                        Text(rejectionText)
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundStyle(Theme.deepRose.opacity(0.85))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                            .opacity(messageOpacity)
                            .animation(.easeInOut(duration: 0.25), value: messageOpacity)
                            .transition(.opacity)
                    }

                    Text("🧸")
                        .font(.system(size: 60))
                        .padding(.vertical, 8)

                    yesButton
                        .padding(.bottom, 8)

                    noButtonContainer(screenWidth: geometry.size.width)

                    Spacer()
                }
            }
        }
    }

    private var yesButton: some View {
        Button {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                showCelebration = true
            }
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        } label: {
            Text("Yes! 💕")
                .font(.system(size: yesFontSize, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.horizontal, yesHPadding)
                .padding(.vertical, 16)
                .background(
                    Capsule()
                        .fill(Theme.buttonGradient)
                        .shadow(color: Theme.deepRose.opacity(0.4), radius: CGFloat(5 + rejectionCount * 2))
                )
                .overlay(Capsule().stroke(Color.white.opacity(0.3), lineWidth: 1))
        }
        .scaleEffect(yesScale)
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: yesScale)
        .scaleEffect(pulseScale)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                pulseScale = 1.06
            }
        }
    }

    private func noButtonContainer(screenWidth: CGFloat) -> some View {
        ZStack {
            Button {
                handleNoTap(containerSize: CGSize(width: screenWidth, height: 200))
            } label: {
                Text(noText)
                    .font(.system(size: noFontSize, weight: .medium, design: .rounded))
                    .foregroundColor(.primary.opacity(0.7))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .stroke(Theme.rosePink.opacity(0.3), lineWidth: 1)
                    )
            }
            .offset(noButtonState.offset)
            .scaleEffect(noButtonState.scale)
            .rotationEffect(.degrees(noButtonState.rotation))
            .opacity(noButtonState.opacity)
            .animation(.spring(response: 0.5, dampingFraction: 0.6), value: noButtonState.offset)
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: noButtonState.scale)
            .animation(.easeInOut(duration: 0.4), value: noButtonState.rotation)
            .animation(.easeInOut(duration: 0.3), value: noButtonState.opacity)
        }
        .frame(width: screenWidth, height: 200)
        .clipped()
    }

    private func handleNoTap(containerSize: CGSize) {
        rejectionCount += 1

        let messageIndex = min(rejectionCount - 1, rejectionMessages.count - 1)

        withAnimation(.easeOut(duration: 0.15)) {
            messageOpacity = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            rejectionText = rejectionMessages[messageIndex]
            withAnimation(.easeIn(duration: 0.2)) {
                messageOpacity = 1.0
            }
        }

        let trick = NoButtonTrick.allCases.randomElement()!
        noButtonState.applyTrick(trick, containerSize: containerSize, rejectionCount: rejectionCount)

        if trick == .fadeAndReappear {
            withAnimation(.easeOut(duration: 0.2)) {
                noButtonState.opacity = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                withAnimation(.easeIn(duration: 0.25)) {
                    noButtonState.opacity = 1.0
                }
            }
        }

        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}

#Preview {
    ContentView()
}
