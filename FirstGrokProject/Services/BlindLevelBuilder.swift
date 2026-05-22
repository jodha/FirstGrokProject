import Foundation

enum BlindLevelBuilder {

    static func makeLevel(
        level: Int,
        smallBlind: Int,
        levelDuration: Int,
        colorUps: inout [Int]
    ) -> BlindLevel {
        let bigBlind = smallBlind * 2
        let colorUpNote = BlindStructureGenerator.colorUpNoteFor(
            level: level,
            colorUps: &colorUps
        )
        let isBreak = level % 6 == 0
        let duration = isBreak ? 10 : levelDuration
        return BlindLevel(
            level: level,
            smallBlind: smallBlind,
            bigBlind: bigBlind,
            durationMinutes: duration,
            isBreak: isBreak,
            colorUpNote: colorUpNote
        )
    }

    static func nextSmallBlind(after smallBlind: Int) -> Int {
        let scaled = Int(Double(smallBlind) * 1.65)
        return BlindStructureGenerator.roundToNice(scaled)
    }
}
