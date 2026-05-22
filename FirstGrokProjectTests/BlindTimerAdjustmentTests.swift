import XCTest
@testable import FirstGrokProject

@MainActor
final class BlindTimerAdjustmentTests: XCTestCase {

    func testAdjustTimeIncreasesRemaining() {
        let model = makeModel()
        model.adjustTime(by: 60)
        XCTAssertEqual(model.timeRemainingSeconds, 1260)
    }

    func testAdjustTimeDecreasesRemaining() {
        let model = makeModel()
        model.adjustTime(by: -60)
        XCTAssertEqual(model.timeRemainingSeconds, 1140)
    }

    func testPauseStopsRunning() {
        let model = makeModel()
        model.resume()
        model.pause()
        XCTAssertFalse(model.isRunning)
    }

    private func makeModel() -> LiveTournamentTimerModel {
        let levels = [BlindLevel(level: 1, smallBlind: 25, bigBlind: 50, durationMinutes: 20)]
        let model = LiveTournamentTimerModel(levels: levels)
        model.timeRemainingSeconds = 1200
        return model
    }
}
