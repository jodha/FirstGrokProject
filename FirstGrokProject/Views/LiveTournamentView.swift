import SwiftUI

struct LiveTournamentView: View {
    let tournament: SavedTournament
    @State private var timerModel: LiveTournamentTimerModel
    @State private var showStartingStack = false

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
            
            // NEW: Expandable Starting Stack Section
            startingStackSection
            
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

    // NEW: Expandable Starting Chip Stack
    private var startingStackSection: some View {
        DisclosureGroup(isExpanded: $showStartingStack) {
            if !tournament.startingChipBreakdown.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(tournament.startingChipBreakdown) { chip in
                        HStack {
                            Text("$\(chip.value)")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Spacer()
                            Text("\(chip.count) chips")
                                .font(.title3)
                        }
                        .padding(.horizontal)
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Total Starting Stack")
                            .font(.headline)
                        Spacer()
                        Text("$\(tournament.initialStack)")
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
            } else {
                Text("Starting stack details not available for this tournament.")
                    .foregroundStyle(.secondary)
                    .padding()
            }
        } label: {
            HStack {
                Image(systemName: "list.bullet")
                Text("Starting Chip Stack (per player)")
                    .font(.headline)
                Spacer()
                Image(systemName: showStartingStack ? "chevron.up" : "chevron.down")
            }
            .foregroundStyle(.primary)
        }
        .padding(.horizontal)
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
