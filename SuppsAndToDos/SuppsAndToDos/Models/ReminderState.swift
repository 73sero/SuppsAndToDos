import Foundation

enum ReminderState: Codable {
    case pending
    case fired
    case snoozed(until: Date)
    case skipped
    case expired

    private enum CodingKeys: String, CodingKey {
        case type
        case until
    }

    private enum StateType: String, Codable {
        case pending, fired, snoozed, skipped, expired
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(StateType.self, forKey: .type)

        switch type {
        case .pending:
            self = .pending
        case .fired:
            self = .fired
        case .skipped:
            self = .skipped
        case .expired:
            self = .expired
        case .snoozed:
            let until = try container.decode(Date.self, forKey: .until)
            self = .snoozed(until: until)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .pending:
            try container.encode(StateType.pending, forKey: .type)
        case .fired:
            try container.encode(StateType.fired, forKey: .type)
        case .skipped:
            try container.encode(StateType.skipped, forKey: .type)
        case .expired:
            try container.encode(StateType.expired, forKey: .type)
        case .snoozed(let until):
            try container.encode(StateType.snoozed, forKey: .type)
            try container.encode(until, forKey: .until)
        }
    }
}
