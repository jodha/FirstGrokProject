import Foundation

enum StartingStackCalculator {

    static func totalChipValue(entries: [(denomination: Int, quantity: Int)]) -> Int {
        entries.reduce(0) { $0 + $1.denomination * $1.quantity }
    }

    static func startingStackValue(totalChipValue: Int, numberOfPlayers: Int) -> Int {
        guard numberOfPlayers > 0 else { return 0 }
        let share = Double(totalChipValue) / Double(numberOfPlayers)
        return Int((share * 0.8).rounded(.down))
    }

    static func suggestedDistribution(
        entries: [(denomination: Int, quantity: Int)],
        stackValuePerPlayer: Int,
        numberOfPlayers: Int
    ) -> [(denomination: Int, quantity: Int)] {
        let sorted = entries.sorted { $0.denomination < $1.denomination }
        let limits = perPlayerLimits(sorted: sorted, numberOfPlayers: numberOfPlayers)
        return StartingStackFillStack.fill(remaining: stackValuePerPlayer, denoms: limits)
    }

    private static func perPlayerLimits(
        sorted: [(denomination: Int, quantity: Int)],
        numberOfPlayers: Int
    ) -> [(denomination: Int, quantity: Int)] {
        sorted.map { (denomination: $0.denomination, quantity: $0.quantity / numberOfPlayers) }
    }
}
