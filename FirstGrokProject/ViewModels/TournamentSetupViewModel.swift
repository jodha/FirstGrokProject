import Foundation
import Observation

@Observable
class TournamentSetupViewModel {
    var chipDenominations: [ChipDenomination] = [
        ChipDenomination(value: 25, count: 20),
        ChipDenomination(value: 100, count: 30),
        ChipDenomination(value: 500, count: 20),
        ChipDenomination(value: 1000, count: 15),
        ChipDenomination(value: 5000, count: 10)
    ]

    var players: Int = 9
    var totalMinutes: Int = 180

    var recommendedStack: [ChipDenomination] = []
    var totalStackValue: Int = 0
    var blindLevels: [BlindLevel] = []
    var colorUpLevels: [Int] = []

    // Normal init (new tournament)
    init() {
        calculateTournament()
    }

    // NEW: Reuse init from saved tournament
    init(from tournament: SavedTournament) {
        self.players = tournament.players
        self.totalMinutes = tournament.totalMinutes
        
        // Load original chip inventory if available, otherwise use defaults
        if !tournament.originalChipInventory.isEmpty {
            self.chipDenominations = tournament.originalChipInventory
        }
        
        calculateTournament()
    }

    func calculateTournament() {
        updateRecommendedStack()
        applyBlindStructure()
    }

    private func updateRecommendedStack() {
        let entries = inventoryEntries()
        let total = StartingStackCalculator.totalChipValue(entries: entries)
        let perPlayer = StartingStackCalculator.startingStackValue(
            totalChipValue: total,
            numberOfPlayers: players
        )
        let dist = StartingStackCalculator.suggestedDistribution(
            entries: entries,
            stackValuePerPlayer: perPlayer,
            numberOfPlayers: players
        )
        recommendedStack = mapDistribution(dist)
        if recommendedStack.isEmpty {
            recommendedStack = defaultFallbackStack()
        }
        totalStackValue = stackSum(recommendedStack)
    }

    private func inventoryEntries() -> [(denomination: Int, quantity: Int)] {
        chipDenominations
            .filter { $0.count > 0 }
            .map { ($0.value, $0.count) }
    }

    private func mapDistribution(
        _ dist: [(denomination: Int, quantity: Int)]
    ) -> [ChipDenomination] {
        dist.map { ChipDenomination(value: $0.denomination, count: $0.quantity) }
    }

    private func stackSum(_ stack: [ChipDenomination]) -> Int {
        stack.reduce(0) { $0 + $1.value * $1.count }
    }

    private func defaultFallbackStack() -> [ChipDenomination] {
        [
            ChipDenomination(value: 25, count: 8),
            ChipDenomination(value: 100, count: 12),
            ChipDenomination(value: 500, count: 8),
            ChipDenomination(value: 1000, count: 5)
        ]
    }

    private func applyBlindStructure() {
        let result = BlindStructureGenerator.generate(
            totalMinutes: totalMinutes,
            totalStackValue: totalStackValue
        )
        blindLevels = result.levels
        colorUpLevels = result.colorUps
    }
}
