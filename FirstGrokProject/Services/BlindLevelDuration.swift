import Foundation

enum BlindLevelDuration {
    private static let defaultMinutes = 20

    static func seconds(for level: Int, in levels: [BlindLevel]) -> Int {
        let minutes = levels.first { $0.level == level }?.durationMinutes ?? defaultMinutes
        return minutes * 60
    }
}
