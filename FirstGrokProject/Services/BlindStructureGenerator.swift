import Foundation

enum BlindStructureGenerator {

    static func generate(
        totalMinutes: Int,
        totalStackValue: Int
    ) -> (levels: [BlindLevel], colorUps: [Int]) {
        var levels: [BlindLevel] = []
        var colorUps: [Int] = []
        let spec = BlindStructureSpec.make(
            totalMinutes: totalMinutes,
            totalStackValue: totalStackValue
        )
        return BlindStructureLoop.fill(
            spec: spec,
            levels: &levels,
            colorUps: &colorUps
        )
    }

    static func addLevel(
        level: Int,
        smallBlind: Int,
        levelDuration: Int,
        levels: inout [BlindLevel],
        colorUps: inout [Int]
    ) -> Int {
        let blind = BlindLevelBuilder.makeLevel(
            level: level,
            smallBlind: smallBlind,
            levelDuration: levelDuration,
            colorUps: &colorUps
        )
        levels.append(blind)
        return BlindLevelBuilder.nextSmallBlind(after: smallBlind)
    }

    static func colorUpNoteFor(level: Int, colorUps: inout [Int]) -> String? {
        if let note = noteForTwentyFive(level: level, colorUps: &colorUps) { return note }
        return noteForHundred(level: level, colorUps: &colorUps)
    }

    private static func noteForTwentyFive(level: Int, colorUps: inout [Int]) -> String? {
        guard level >= 5 && level % 4 == 1 else { return nil }
        colorUps.append(level)
        return "Color-up: Remove 25s"
    }

    private static func noteForHundred(level: Int, colorUps: inout [Int]) -> String? {
        guard level >= 9 && level % 5 == 0 else { return nil }
        colorUps.append(level)
        return "Color-up: Remove 100s"
    }

    static func roundToNice(_ value: Int) -> Int {
        if value <= 100 { return ((value + 12) / 25) * 25 }
        if value <= 1000 { return ((value + 24) / 50) * 50 }
        return ((value + 49) / 100) * 100
    }
}
