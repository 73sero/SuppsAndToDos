import Foundation

enum AccentColor: String {
    case white
    case blue
    case green
}

final class SettingsViewModel {

    private(set) var dayChangeHour: Int
    private(set) var accentColor: AccentColor
    private(set) var qrEnabled: Bool
    private(set) var statisticsEnabled: Bool
    private(set) var premiumUnlocked: Bool

    init(
        dayChangeHour: Int = 0,
        accentColor: AccentColor = .white,
        qrEnabled: Bool = false,
        statisticsEnabled: Bool = false,
        premiumUnlocked: Bool = false
    ) {
        self.dayChangeHour = dayChangeHour
        self.accentColor = accentColor
        self.qrEnabled = qrEnabled
        self.statisticsEnabled = statisticsEnabled
        self.premiumUnlocked = premiumUnlocked
    }
}