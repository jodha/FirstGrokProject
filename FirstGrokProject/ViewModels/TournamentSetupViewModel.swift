//
//  TournamentSetupViewModel.swift
//  FirstGrokProject
//
//  Created by Urvashi Bhardwaj on 5/12/26.
//


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
    var totalMinutes: Int = 180   // 3 hours default
    
    var calculatedInitialStack: Int = 1500
    var blindLevels: [BlindLevel] = []
    var colorUpLevels: [Int] = []
    
    func calculateTournament() {
        let totalChipsValue = chipDenominations.reduce(0) { $0 + $1.value * $1.count }
        calculatedInitialStack = max(1000, totalChipsValue / max(1, players))
        
        generateBlindStructure()
    }
    
    private func generateBlindStructure() {
        blindLevels.removeAll()
        colorUpLevels.removeAll()
        
        let numLevels = max(10, totalMinutes / 18)           // ~18 min per level
        let levelDuration = totalMinutes / numLevels
        
        var smallBlind = max(25, calculatedInitialStack / 50)
        smallBlind = roundToNice(smallBlind)
        
        for level in 1...numLevels {
            let bigBlind = smallBlind * 2
            
            var colorUpNote: String? = nil
            if level >= 5 && level % 4 == 1 {
                colorUpNote = "Color-up: Remove 25s"
                colorUpLevels.append(level)
            } else if level >= 8 && level % 5 == 0 {
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
            
            // Increase blinds for next level
            smallBlind = Int(Double(smallBlind) * 1.6)
            smallBlind = roundToNice(smallBlind)
        }
    }
    
    private func roundToNice(_ value: Int) -> Int {
        if value <= 100 { return ((value + 12) / 25) * 25 }
        if value <= 1000 { return ((value + 24) / 50) * 50 }
        return ((value + 49) / 100) * 100
    }
}