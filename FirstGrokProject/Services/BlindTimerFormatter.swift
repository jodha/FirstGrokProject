import Foundation

enum BlindTimerFormatter {
    private static let maxSeconds = 28_800

    static func format(seconds: Int) -> String {
        let clamped = clamp(seconds: seconds)
        let minutes = clamped / 60
        let secs = clamped % 60
        return String(format: "%02d:%02d", minutes, secs)
    }

    static func clamp(seconds: Int) -> Int {
        min(max(seconds, 0), maxSeconds)
    }

    static func totalSeconds(minutes: Int, seconds: Int) -> Int {
        clamp(seconds: minutes * 60 + seconds)
    }

    static func minutes(from totalSeconds: Int) -> Int {
        clamp(seconds: totalSeconds) / 60
    }

    static func secondsPart(from totalSeconds: Int) -> Int {
        clamp(seconds: totalSeconds) % 60
    }
}
