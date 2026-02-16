import SwiftUI

enum AppColor {

    static let background = Color.black

    static let primaryText = Color.white
    static let secondaryText = Color.gray

    static let cardBackground = Color.white.opacity(0.09)
    static let cardBackgroundDone = Color.white.opacity(0.04)

    static let accent = Color.white
    static let accentMuted = Color.white.opacity(0.35)

    static let divider = Color.white.opacity(0.35)
}

enum AppFont {

    static func title(_ weight: Font.Weight = .bold) -> Font {
        .system(size: 24, weight: weight)
    }

    static func sectionLabel() -> Font {
        .system(size: 12, weight: .medium)
    }

    static func body(_ weight: Font.Weight = .medium) -> Font {
        .system(size: 16, weight: weight)
    }

    static func subtitle() -> Font {
        .system(size: 13)
    }

    static func small() -> Font {
        .system(size: 11)
    }
}
