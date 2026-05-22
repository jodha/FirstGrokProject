import SwiftUI

struct LiveTournamentView: View {
    let tournament: SavedTournament
    @State private var timerModel: LiveTournamentTimerModel

    init(tournament: SavedTournament) {
        self.tournament = tournament
        _timerModel = State(initialValue: LiveTournamentTimerModel(levels: tournament.blindLevels))
    }

    var body: some View {
        VStack(spacing: 24) {
            levelHeader
            BlindTimerDisplayView(timerModel: timerModel)
            nextLevelButton
            colorUpAlert
            upcomingBlindsList
        }
        .navigationTitle(tournament.name)
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear { timerModel.pause() }
    }

    private var levelHeader: some View {
        LiveTournamentLevelHeaderView(
            currentLevel: timerModel.currentLevel,
            blindLevel: currentBlindLevel
        )
    }

    private var nextLevelButton: some View {
        Button("Next Level") { timerModel.advanceLevel() }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .disabled(!timerModel.canAdvanceLevel())
    }

    @ViewBuilder
    private var colorUpAlert: some View {
        if let note = currentBlindLevel?.colorUpNote {
            Text(note)
                .foregroundStyle(.orange)
                .font(.headline)
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(12)
        }
    }

    private var upcomingBlindsList: some View {
        List {
            Section("Upcoming Blinds") {
                ForEach(upcomingLevels) { level in
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

    private var currentBlindLevel: BlindLevel? {
        tournament.blindLevels.first { $0.level == timerModel.currentLevel }
    }

    private var upcomingLevels: [BlindLevel] {
        tournament.blindLevels
            .filter { $0.level > timerModel.currentLevel }
            .prefix(5)
            .map { $0 }
    }
}
