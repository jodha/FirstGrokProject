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
        ZStack {
            // Green Felt Background
            Image("GreenFelt")
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
                .opacity(0.9)
            
            VStack(spacing: 20) {
                levelHeader
                
                // Dealer Button
                Image("DealerButton")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .shadow(radius: 4)
                
                BlindTimerDisplayView(timerModel: timerModel)
                nextLevelButton
                colorUpAlert
                
                // Chip Stack Image
                Image("ChipStack")
                    .resizable()
                    .frame(height: 80)
                    .cornerRadius(12)
                    .shadow(radius: 3)
                
                startingStackSection
                upcomingBlindsList
            }
            .padding(.horizontal)
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
            .buttonStyle(.borderedProminent)
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
                .background(Color.black.opacity(0.6))
                .cornerRadius(12)
        }
    }

    private var startingStackSection: some View {
        DisclosureGroup(isExpanded: $showStartingStack) {
            if !tournament.startingChipBreakdown.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(tournament.startingChipBreakdown) { chip in
                        HStack {
                            Text("$\(chip.value)")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                            Spacer()
                            Text("\(chip.count) chips")
                                .font(.title3)
                                .foregroundStyle(.white)
                        }
                        .padding(.horizontal)
                    }
                    
                    Divider().background(Color.white.opacity(0.3))
                    
                    HStack {
                        Text("Total Starting Stack")
                            .font(.headline)
                            .foregroundStyle(.white)
                        Spacer()
                        Text("$\(tournament.initialStack)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
            } else {
                Text("Starting stack details not available.")
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
            .foregroundStyle(.white)
        }
        .padding(.horizontal)
        .background(Color.black.opacity(0.4))
        .cornerRadius(12)
    }

    private var upcomingBlindsList: some View {
        List {
            Section("Upcoming Blinds") {
                ForEach(upcomingLevels) { level in
                    HStack {
                        Text("Level \(level.level)")
                            .foregroundStyle(.white)
                        Spacer()
                        Text("\(level.smallBlind) / \(level.bigBlind)")
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    .listRowBackground(Color.black.opacity(0.3))
                }
            }
        }
        .scrollContentBackground(.hidden)
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
