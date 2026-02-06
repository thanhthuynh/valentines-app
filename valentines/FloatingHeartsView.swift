import SwiftUI

struct FloatingHeart: Identifiable {
    let id = UUID()
    var x: CGFloat
    var speed: CGFloat
    var size: CGFloat
    var opacity: Double
    var wobbleAmount: CGFloat
    var wobbleSpeed: CGFloat
    var colorIndex: Int
    var startOffset: CGFloat
}

struct FloatingHeartsView: View {
    let heartCount: Int
    @State private var hearts: [FloatingHeart] = []

    init(count: Int = 15) {
        self.heartCount = count
    }

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let now = timeline.date.timeIntervalSinceReferenceDate

                for heart in hearts {
                    let elapsed = now * heart.speed + Double(heart.startOffset)
                    let normalizedY = (elapsed.truncatingRemainder(dividingBy: 1.3)) / 1.3
                    let y = size.height * (1.0 - normalizedY) + heart.size

                    let wobble = sin(now * Double(heart.wobbleSpeed) + Double(heart.startOffset)) * Double(heart.wobbleAmount)
                    let x = heart.x * size.width + wobble

                    let emoji: String
                    switch heart.colorIndex % 4 {
                    case 0: emoji = "💗"
                    case 1: emoji = "💕"
                    case 2: emoji = "💜"
                    default: emoji = "💖"
                    }

                    let text = Text(emoji)
                        .font(.system(size: heart.size))

                    let resolved = context.resolve(text)
                    let point = CGPoint(x: x, y: y)
                    context.opacity = heart.opacity * (1.0 - normalizedY * 0.5)
                    context.draw(resolved, at: point)
                }
            }
        }
        .onAppear {
            hearts = (0..<heartCount).map { _ in
                FloatingHeart(
                    x: CGFloat.random(in: 0.05...0.95),
                    speed: CGFloat.random(in: 0.08...0.2),
                    size: CGFloat.random(in: 12...28),
                    opacity: Double.random(in: 0.15...0.4),
                    wobbleAmount: CGFloat.random(in: 10...30),
                    wobbleSpeed: CGFloat.random(in: 0.5...2.0),
                    colorIndex: Int.random(in: 0...3),
                    startOffset: CGFloat.random(in: 0...100)
                )
            }
        }
        .allowsHitTesting(false)
    }
}
