import Foundation
import SwiftData

@Model
class SavedTournament {
    var id: UUID
    var name: String
    var dateCreated: Date
    var players: Int
    var totalMinutes: Int
    var initialStack: Int
    var startingSmallBlind: Int
    var blindLevels: [BlindLevel]
    var colorUpLevels: [Int]
    
    init(name: String, players: Int, totalMinutes: Int, initialStack: Int,
         startingSmallBlind: Int, blindLevels: [BlindLevel], colorUpLevels: [Int]) {
        self.id = UUID()
        self.name = name
        self.dateCreated = Date()
        self.players = players
        self.totalMinutes = totalMinutes
        self.initialStack = initialStack
        self.startingSmallBlind = startingSmallBlind
        self.blindLevels = blindLevels
        self.colorUpLevels = colorUpLevels
    }
}

struct BlindLevel: Codable, Identifiable, Hashable {
    var id = UUID()
    var level: Int
    var smallBlind: Int
    var bigBlind: Int
    var durationMinutes: Int
    var isBreak: Bool = false
    var colorUpNote: String? = nil
}

struct ChipDenomination: Identifiable, Codable, Hashable {
    var id = UUID()
    var value: Int
    var count: Int
}