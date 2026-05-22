import XCTest
@testable import FirstGrokProject

final class BlindLevelDurationTests: XCTestCase {

    func testSecondsUsesLevelDurationMinutes() {
        let levels = [BlindLevel(level: 1, smallBlind: 25, bigBlind: 50, durationMinutes: 15)]
        XCTAssertEqual(BlindLevelDuration.seconds(for: 1, in: levels), 900)
    }

    func testSecondsDefaultsWhenLevelMissing() {
        XCTAssertEqual(BlindLevelDuration.seconds(for: 9, in: []), 1200)
    }
}
