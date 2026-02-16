import Foundation

enum MockData {

    // MARK: - Items
    static let items: [Item] = [
        Item(
            id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!,
            title: "Vitamin D3",
            type: .supplement,
            isActive: true,
            createdAt: Date().addingTimeInterval(-86400),
            unit: .mg,
            amount: 2000
        ),
        Item(
            id: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!,
            title: "Magnesium",
            type: .supplement,
            isActive: true,
            createdAt: Date().addingTimeInterval(-172800),
            unit: .mg,
            amount: 400
        ),
        Item(
            id: UUID(uuidString: "33333333-3333-3333-3333-333333333333")!,
            title: "Workout",
            type: .todo,
            isActive: true,
            createdAt: Date().addingTimeInterval(-259200),
            unit: nil,
            amount: nil
        )
    ]

    // MARK: - Schedules
    static let schedules: [UUID: Schedule] = [
        items[0].id: Schedule(
            time: Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!,
            repeatRule: .daily,
            weekdays: nil,
            slotID: "morning",
            notificationsEnabled: true
        ),
        items[1].id: Schedule(
            time: Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!,
            repeatRule: .daily,
            weekdays: nil,
            slotID: "noon",
            notificationsEnabled: true
        ),
        items[2].id: Schedule(
            time: Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date())!,
            repeatRule: .daily,
            weekdays: nil,
            slotID: "evening",
            notificationsEnabled: false
        )
    ]

    // MARK: - Statuses
    static let statuses: [ItemStatus] = [
        ItemStatus(
            id: UUID(),
            itemID: items[0].id,
            date: Date(),
            slotID: "morning",
            status: .open,
            completedAt: nil,
            confirmation: nil
        ),
        ItemStatus(
            id: UUID(),
            itemID: items[1].id,
            date: Date(),
            slotID: "noon",
            status: .done,
            completedAt: Date().addingTimeInterval(-3600),
            confirmation: .tap
        ),
        ItemStatus(
            id: UUID(),
            itemID: items[2].id,
            date: Date(),
            slotID: "evening",
            status: .open,
            completedAt: nil,
            confirmation: nil
        )
    ]
}
