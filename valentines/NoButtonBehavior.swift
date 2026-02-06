import SwiftUI

enum NoButtonTrick: CaseIterable {
    case randomMove
    case shrinkAndMove
    case spinAndMove
    case fadeAndReappear
    case runToCorner
    case flipAndMove
}

struct NoButtonState {
    var offset: CGSize = .zero
    var scale: CGFloat = 1.0
    var rotation: Double = 0
    var opacity: Double = 1.0
    var isHidden: Bool = false

    mutating func applyTrick(_ trick: NoButtonTrick, containerSize: CGSize, rejectionCount: Int) {
        let maxX = containerSize.width / 2 - 60
        let maxY = containerSize.height / 2 - 30
        let randomX = CGFloat.random(in: -maxX...maxX)
        let randomY = CGFloat.random(in: -maxY...maxY)

        let shrinkFactor = max(1.0 - Double(rejectionCount) * 0.04, 0.4)

        switch trick {
        case .randomMove:
            offset = CGSize(width: randomX, height: randomY)
            scale = shrinkFactor

        case .shrinkAndMove:
            offset = CGSize(width: randomX, height: randomY)
            scale = shrinkFactor * 0.8

        case .spinAndMove:
            offset = CGSize(width: randomX, height: randomY)
            rotation += 360
            scale = shrinkFactor

        case .fadeAndReappear:
            opacity = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                // Will be handled in ContentView
            }
            offset = CGSize(width: randomX, height: randomY)
            scale = shrinkFactor

        case .runToCorner:
            let corners: [CGSize] = [
                CGSize(width: maxX, height: maxY),
                CGSize(width: -maxX, height: maxY),
                CGSize(width: maxX, height: -maxY),
                CGSize(width: -maxX, height: -maxY),
            ]
            offset = corners.randomElement()!
            scale = shrinkFactor

        case .flipAndMove:
            offset = CGSize(width: randomX, height: randomY)
            rotation += 180
            scale = shrinkFactor
        }
    }
}
