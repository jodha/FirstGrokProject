import XCTest
@testable import FirstGrokProject

final class BlindTimerFormatterTests: XCTestCase {

    func testFormatDisplaysMinutesAndSeconds() {
        XCTAssertEqual(BlindTimerFormatter.format(seconds: 125), "02:05")
    }

    func testClampRejectsNegativeValues() {
        XCTAssertEqual(BlindTimerFormatter.clamp(seconds: -5), 0)
    }

    func testClampCapsAtEightHours() {
        XCTAssertEqual(BlindTimerFormatter.clamp(seconds: 30_000), 28_800)
    }

    func testCombineMinutesAndSeconds() {
        XCTAssertEqual(BlindTimerFormatter.totalSeconds(minutes: 3, seconds: 45), 225)
    }
}
