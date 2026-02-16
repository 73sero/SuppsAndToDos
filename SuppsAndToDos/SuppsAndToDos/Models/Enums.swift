import Foundation

enum ConfirmationMethod: String, Codable {
    case tap
    case reminder
}

enum RepeatRule: String {
    case daily
    case custom
}
