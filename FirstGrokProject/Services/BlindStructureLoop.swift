import Foundation

enum BlindStructureLoop {

    static func fill(
        spec: BlindStructureSpec,
        levels: inout [BlindLevel],
        colorUps: inout [Int]
    ) -> (levels: [BlindLevel], colorUps: [Int]) {
        var smallBlind = spec.initialSmallBlind
        for level in 1...spec.numLevels {
            smallBlind = BlindStructureGenerator.addLevel(
                level: level,
                smallBlind: smallBlind,
                levelDuration: spec.levelDuration,
                levels: &levels,
                colorUps: &colorUps
            )
        }
        return (levels, colorUps)
    }
}
