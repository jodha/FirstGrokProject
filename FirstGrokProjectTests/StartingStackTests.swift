import XCTest
@testable import FirstGrokProject

final class StartingStackTests: XCTestCase {

    func testTotalChipValueSumsDenominationTimesQuantity() {
        let entries = [(25, 100), (100, 50), (500, 20)]
        let total = StartingStackCalculator.totalChipValue(entries: entries)
        XCTAssertEqual(total, 25 * 100 + 100 * 50 + 500 * 20)
    }

    func testPerPlayerStackUsesEightyPercentOfTotalDividedByPlayers() {
        let total = 80_000
        let perPlayer = StartingStackCalculator.startingStackValue(
            totalChipValue: total,
            numberOfPlayers: 8
        )
        XCTAssertEqual(perPlayer, 8_000)
    }

    func testSuggestedDistributionMatchesPerPlayerValue() {
        let entries = [(25, 320), (100, 240), (500, 64)]
        let perPlayer = 8000
        let dist = StartingStackCalculator.suggestedDistribution(
            entries: entries,
            stackValuePerPlayer: perPlayer,
            numberOfPlayers: 8
        )
        let sum = dist.reduce(0) { $0 + $1.denomination * $1.quantity }
        XCTAssertEqual(sum, perPlayer)
    }

    func testSuggestedStackNotEmptyForDefaultInventory() {
        let entries = [(25, 20), (100, 30), (500, 20), (1000, 15), (5000, 10)]
        let total = StartingStackCalculator.totalChipValue(entries: entries)
        let perPlayer = StartingStackCalculator.startingStackValue(
            totalChipValue: total,
            numberOfPlayers: 9
        )
        let dist = StartingStackCalculator.suggestedDistribution(
            entries: entries,
            stackValuePerPlayer: perPlayer,
            numberOfPlayers: 9
        )
        XCTAssertFalse(dist.isEmpty)
    }
}
