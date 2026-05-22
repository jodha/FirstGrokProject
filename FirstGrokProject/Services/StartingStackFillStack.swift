import Foundation

enum StartingStackFillStack {

    static func fill(
        remaining: Int,
        denoms: [(denomination: Int, quantity: Int)]
    ) -> [(denomination: Int, quantity: Int)] {
        guard remaining > 0, let first = denoms.first else { return [] }
        return takeFromFirst(remaining: remaining, first: first, rest: Array(denoms.dropFirst()))
    }

    private static func takeFromFirst(
        remaining: Int,
        first: (denomination: Int, quantity: Int),
        rest: [(denomination: Int, quantity: Int)]
    ) -> [(denomination: Int, quantity: Int)] {
        let maxCount = min(first.quantity, remaining / first.denomination)
        guard maxCount > 0 else { return fill(remaining: remaining, denoms: rest) }
        return buildTake(remaining: remaining, first: first, take: maxCount, rest: rest)
    }

    private static func buildTake(
        remaining: Int,
        first: (denomination: Int, quantity: Int),
        take: Int,
        rest: [(denomination: Int, quantity: Int)]
    ) -> [(denomination: Int, quantity: Int)] {
        let used = first.denomination * take
        let tail = fill(remaining: remaining - used, denoms: rest)
        return [(denomination: first.denomination, quantity: take)] + tail
    }
}
