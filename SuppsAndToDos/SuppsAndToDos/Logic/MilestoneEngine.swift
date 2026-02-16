import Foundation

final class MilestoneEngine {

    // Tolerance threshold
    private let completionThreshold: Double = 0.8

    func milestones(
        statuses: [ItemStatus],
        items: [Item]
    ) -> [Milestone] {

        var result: [Milestone] = []

        // PER ITEM
        for item in items {

            let doneCount = statuses.filter {
                $0.itemID == item.id && $0.status == .done
            }.count

            result.append(
                milestone(
                    title: "First 7 Days",
                    subtitle: item.title,
                    target: 7,
                    done: doneCount,
                    itemID: item.id,
                    itemType: item.type
                )
            )

            result.append(
                milestone(
                    title: "Consistency",
                    subtitle: item.title,
                    target: 30,
                    done: doneCount,
                    itemID: item.id,
                    itemType: item.type
                )
            )
        }

        // GLOBAL
        let globalDone = statuses.filter { $0.status == .done }.count

        result.append(
            milestone(
                title: "Reliability",
                subtitle: "All routines",
                target: 100,
                done: globalDone,
                itemID: nil,
                itemType: nil
            )
        )

        return result
    }

    private func milestone(
        title: String,
        subtitle: String,
        target: Int,
        done: Int,
        itemID: UUID?,
        itemType: ItemType?
    ) -> Milestone {

        let capped = min(done, target)
        let ratio = target == 0 ? 0 : Double(capped) / Double(target)
        let tolerantCompleted = ratio >= completionThreshold

        return Milestone(
            id: UUID(),
            title: title,
            subtitle: subtitle,
            targetCount: target,
            currentCount: capped,
            relatedItemID: itemID,
            relatedItemType: itemType,
            isCompleted: tolerantCompleted
        )
    }
}
