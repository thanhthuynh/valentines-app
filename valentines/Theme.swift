import SwiftUI

enum Theme {
    static let softBlush = Color("SoftBlush")
    static let rosePink = Color("RosePink")
    static let deepRose = Color("DeepRose")
    static let romanticPurple = Color("RomanticPurple")
    static let softLavender = Color("SoftLavender")

    static let backgroundGradient = LinearGradient(
        colors: [softBlush.opacity(0.6), softLavender.opacity(0.5), rosePink.opacity(0.3)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let celebrationGradient = LinearGradient(
        colors: [rosePink.opacity(0.4), romanticPurple.opacity(0.4), softBlush.opacity(0.5)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let buttonGradient = LinearGradient(
        colors: [deepRose, romanticPurple],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let celebrationTextGradient = LinearGradient(
        colors: [deepRose, romanticPurple, rosePink],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let heartColors: [Color] = [rosePink, deepRose, romanticPurple, softLavender]
}
