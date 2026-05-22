import Foundation
import Observation

@MainActor
@Observable
final class LiveTournamentTimerModel {
    var currentLevel: Int = 1
    var timeRemainingSeconds: Int = 0
    var isRunning: Bool = false
    var hasManualOverride: Bool = false
    private var timer: Timer?
    private let levels: [BlindLevel]

    init(levels: [BlindLevel]) {
        self.levels = levels
        applyLevelDefault()
    }

    func applyLevelDefault() {
        timeRemainingSeconds = BlindLevelDuration.seconds(for: currentLevel, in: levels)
        hasManualOverride = false
    }

    func adjustTime(by delta: Int) {
        timeRemainingSeconds = BlindTimerFormatter.clamp(
            seconds: timeRemainingSeconds + delta
        )
        hasManualOverride = true
    }

    func pause() {
        stopTimer()
    }

    func resume() {
        guard !isRunning else { return }
        startTimer()
    }

    func toggleRunning() {
        isRunning ? pause() : resume()
    }

    func advanceLevel() {
        guard currentLevel < levels.count else { return }
        currentLevel += 1
        applyLevelDefault()
    }

    func canAdvanceLevel() -> Bool {
        currentLevel < levels.count
    }

    func startTimer() {
        pause()
        isRunning = true
        let newTimer = Timer(timeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.tick() }
        }
        RunLoop.main.add(newTimer, forMode: .common)
        timer = newTimer
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }

    private func tick() {
        guard timeRemainingSeconds > 0 else {
            handleLevelExpired()
            return
        }
        timeRemainingSeconds -= 1
    }

    private func handleLevelExpired() {
        guard canAdvanceLevel() else {
            pause()
            return
        }
        advanceLevel()
    }
}
