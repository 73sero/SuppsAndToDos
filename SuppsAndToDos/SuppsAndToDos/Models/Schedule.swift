import Foundation

struct Schedule {
    let time: Date
    let repeatRule: RepeatRule
    let weekdays: Set<Int>?
    let slotID: String
    let notificationsEnabled: Bool
}
