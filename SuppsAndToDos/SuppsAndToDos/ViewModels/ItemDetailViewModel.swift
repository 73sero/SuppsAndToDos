import Foundation
import Combine

final class ItemDetailViewModel: ObservableObject {

    // MARK: - Input

    @Published var title: String = ""
    @Published var type: ItemType = .supplement

    // Supps only
    @Published var unit: SupplementUnit = .mg
    @Published var amountText: String = ""

    // MARK: - Output

    func buildItem() -> Item? {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return nil }

        switch type {
        case .supplement:
            guard let amount = Double(amountText) else { return nil }

            return Item(
                id: UUID(),
                title: trimmedTitle,
                type: .supplement,
                isActive: true,
                createdAt: Date(),
                unit: unit,
                amount: amount
            )

        case .todo:
            return Item(
                id: UUID(),
                title: trimmedTitle,
                type: .todo,
                isActive: true,
                createdAt: Date(),
                unit: nil,
                amount: nil
            )
        }
    }
}
