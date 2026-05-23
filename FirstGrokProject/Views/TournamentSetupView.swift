import SwiftUI
import SwiftData

struct TournamentSetupView: View {
    @Bindable var viewModel: TournamentSetupViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            Form {
                tournamentSettingsSection
                ChipInventorySectionView(viewModel: viewModel)
                StartingStackDisplayView(
                    totalStackValue: viewModel.totalStackValue,
                    recommendedStack: viewModel.recommendedStack
                )
            }
            .navigationTitle("New Tournament")
            .toolbar { toolbarContent }
            .onAppear { viewModel.calculateTournament() }
            .onChange(of: viewModel.players) { _, _ in
                viewModel.calculateTournament()
            }
            .onChange(of: viewModel.totalMinutes) { _, _ in
                viewModel.calculateTournament()
            }
        }
    }

    private var tournamentSettingsSection: some View {
        Section("Tournament Settings") {
            Picker("Number of Players", selection: $viewModel.players) {
                ForEach([6, 8, 9, 10, 12], id: \.self) {
                    Text("\($0) players").tag($0)
                }
            }
            Picker("Tournament Duration", selection: $viewModel.totalMinutes) {
                Text("2 Hours (120 min)").tag(120)
                Text("3 Hours (180 min)").tag(180)
                Text("4 Hours (240 min)").tag(240)
                Text("5 Hours (300 min)").tag(300)
            }
        }
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") { dismiss() }
        }
        ToolbarItem(placement: .confirmationAction) {
            Button("Start Tournament") { startTournament() }
                .font(.headline)
        }
    }

    private func startTournament() {
        let newTournament = SavedTournament(
            name: "Tournament \(Date.now.formatted(date: .abbreviated, time: .shortened))",
            players: viewModel.players,
            totalMinutes: viewModel.totalMinutes,
            initialStack: viewModel.totalStackValue,
            startingSmallBlind: viewModel.blindLevels.first?.smallBlind ?? 25,
            blindLevels: viewModel.blindLevels,
            colorUpLevels: viewModel.colorUpLevels,
            startingChipBreakdown: viewModel.recommendedStack,
            originalChipInventory: viewModel.chipDenominations
        )
        modelContext.insert(newTournament)
        dismiss()
    }
}
