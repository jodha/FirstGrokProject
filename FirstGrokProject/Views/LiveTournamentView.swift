//
//  LiveTournamentView.swift
//  FirstGrokProject
//
//  Created by Urvashi Bhardwaj on 5/12/26.
//


import SwiftUI

struct LiveTournamentView: View {
    let tournament: SavedTournament
    @State private var currentLevel = 1
    @State private var timeRemaining: Int = 0
    @State private var isRunning = false
    @State private var timer: Timer?
    
    init(tournament: SavedTournament) {
        self.tournament = tournament
        // Fixed: Use full minutes * 60
        let firstLevelDuration = tournament.blindLevels.first?.durationMinutes ?? 20
        self._timeRemaining = State(initialValue: firstLevelDuration * 60)
    }
    
    // ... rest of the view stays the same
    
    var body: some View {
        VStack(spacing: 24) {
            // Current Level
            VStack {
                Text("Level \(currentLevel)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                if let level = tournament.blindLevels.first(where: { $0.level == currentLevel }) {
                    HStack(spacing: 40) {
                        VStack {
                            Text("\(level.smallBlind)")
                                .font(.system(size: 48, weight: .bold))
                            Text("Small Blind")
                                .font(.caption)
                        }
                        VStack {
                            Text("\(level.bigBlind)")
                                .font(.system(size: 48, weight: .bold))
                            Text("Big Blind")
                                .font(.caption)
                        }
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(16)
            
            // Timer
            Text(formatTime(timeRemaining))
                .font(.system(size: 72, weight: .bold, design: .monospaced))
                .foregroundStyle(isRunning ? .green : .primary)
            
            // Controls
            HStack(spacing: 20) {
                Button(isRunning ? "Pause" : "Start") {
                    toggleTimer()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                
                Button("Next Level") {
                    nextLevel()
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            }
            
            // Color-up Alert
            if let level = tournament.blindLevels.first(where: { $0.level == currentLevel }),
               let note = level.colorUpNote {
                Text(note)
                    .foregroundStyle(.orange)
                    .font(.headline)
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
            }
            
            List {
                Section("Upcoming Blinds") {
                    ForEach(tournament.blindLevels.filter { $0.level > currentLevel }.prefix(5)) { level in
                        HStack {
                            Text("Level \(level.level)")
                            Spacer()
                            Text("\(level.smallBlind) / \(level.bigBlind)")
                        }
                        .foregroundStyle(level.isBreak ? .blue : .primary)
                    }
                }
            }
        }
        .navigationTitle(tournament.name)
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", minutes, secs)
    }
    
    private func toggleTimer() {
        isRunning.toggle()
        if isRunning {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    nextLevel()
                }
            }
        } else {
            timer?.invalidate()
        }
    }
    
    private func nextLevel() {
        if currentLevel < tournament.blindLevels.count {
            currentLevel += 1
            if let nextLevelData = tournament.blindLevels.first(where: { $0.level == currentLevel }) {
                timeRemaining = nextLevelData.durationMinutes * 60
            }
        }
    }
}
