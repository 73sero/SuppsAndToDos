import Foundation

extension ItemType {

    func matches(_ category: ItemCategory) -> Bool {
        switch (self, category) {
        case (.supplement, .supplement):
            return true
        case (.todo, .todo):
            return true
        default:
            return false
        }
    }
}
