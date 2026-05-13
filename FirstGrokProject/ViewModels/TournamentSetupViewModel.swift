import Foundation
import Observation

@Observable
class TournamentSetupViewModel {
    var chipDenominations: [ChipDenomination] = [
        ChipDenomination(value: 25, count: 20),
        ChipDenomination(value: 100, count: 30),
        ChipDenomination(value: 500, count: 20),
        ChipDenomination(value: 1000, count: 15),
        ChipDenomination(value: 5000, count: 10)
    ]
    
    var players: Int = 9
    var totalMinutes: Int = 180
    
    var recommendedStack: [ChipDenomination] = []
    var totalStackValue: Int = 0
    var blindLevels: [BlindLevel] = []
    var colorUpLevels: [Int] = []
    
    init() {
        calculateTournament()
    }
    
    func calculateTournament() {
        recommendedStack = calculateChipDistribution()
        totalStackValue = recommendedStack.reduce(0) { $0 + $1.value * $1.count }
        generateBlindStructure()
    }
    
    private func calculateChipDistribution() -> [ChipDenomination] {
        var distribution: [ChipDenomination] = []
        
        for denom in chipDenominations where denom.count > 0 {
            // Distribute fairly
            let chipsPerPlayer = max(2, denom.count / players)
            if chipsPerPlayer > 0 {
                distribution.append(ChipDenomination(
                    value: denom.value,
                    count: chipsPerPlayer
                ))
            }
        }
        
        // Minimum reasonable stack fallback
        if distribution.isEmpty || totalStackValue < 5000 {
            distribution = [
                ChipDenomination(value: 25, count: 8),
                ChipDenomination(value: 100, count: 12),
                ChipDenomination(value: 500, count: 8),
                ChipDenomination(value: 1000, count: 5)
            ]
        }
        
        return distribution
    }
    
    private func generateBlindStructure() {
        blindLevels.removeAll()
        colorUpLevels.removeAll()
        
        let numLevels = max(10, totalMinutes / 20)
        let levelDuration = totalMinutes / numLevels
        
        var smallBlind = max(25, totalStackValue / 60)
        smallBlind = roundToNice(smallBlind)
        
        for level in 1...numLevels {
            let bigBlind = smallBlind * 2
            var colorUpNote: String? = nil
            
            if level >= 5 && level % 4 == 1 {
                colorUpNote = "Color-up: Remove 25s"
                colorUpLevels.append(level)
            } else if level >= 9 && level % 5 == 0 {
                colorUpNote = "Color-up: Remove 100s"
                colorUpLevels.append(level)
            }
            
            let isBreak = level % 6 == 0
            
            blindLevels.append(BlindLevel(
                level: level,
                smallBlind: smallBlind,
                bigBlind: bigBlind,
                durationMinutes: isBreak ? 10 : levelDuration,
                isBreak: isBreak,
                colorUpNote: colorUpNote
            ))
            
            smallBlind = Int(Double(smallBlind) * 1.65)
            smallBlind = roundToNice(smallBlind)
        }
    }
    
    private func roundToNice(_ value: Int) -> Int {
        if value <= 100 { return ((value + 12) / 25) * 25 }
        if value <= 1000 { return ((value + 24) / 50) * 50 }
        return ((value + 49) / 100) * 100
    }
}
