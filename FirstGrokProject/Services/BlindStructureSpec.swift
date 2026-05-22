import Foundation

struct BlindStructureSpec {
    let numLevels: Int
    let levelDuration: Int
    let initialSmallBlind: Int

    static func make(totalMinutes: Int, totalStackValue: Int) -> BlindStructureSpec {
        let numLevels = max(10, totalMinutes / 20)
        let levelDuration = totalMinutes / numLevels
        let rawBlind = max(25, totalStackValue / 60)
        let initial = BlindStructureGenerator.roundToNice(rawBlind)
        return BlindStructureSpec(
            numLevels: numLevels,
            levelDuration: levelDuration,
            initialSmallBlind: initial
        )
    }
}
