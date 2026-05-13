import SwiftUI
import SwiftData     // ← Add this line

struct TournamentSetupView: View {
    @Bindable var viewModel: TournamentSetupViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Tournament Settings") {
                    Picker("Number of Players", selection: $viewModel.players) {
                        ForEach([6, 8, 9, 10, 12], id: \.self) { Text("\($0) players").tag($0) }
                    }
                    
                    Picker("Tournament Duration", selection: $viewModel.totalMinutes) {
                        Text("2 Hours (120 min)").tag(120)
                        Text("3 Hours (180 min)").tag(180)
                        Text("4 Hours (240 min)").tag(240)
                        Text("5 Hours (300 min)").tag(300)
                    }
                }
                
                Section("Chip Denominations") {
                    ForEach($viewModel.chipDenominations) { $denom in
                        HStack {
                            Text("\(denom.value)")
                            Spacer()
                            Stepper("\(denom.count)", value: $denom.count, in: 0...100)
                        }
                    }
                }
                
                Section("Results") {
                    Text("Recommended Starting Stack")
                        .font(.headline)
                    Text("\(viewModel.calculatedInitialStack)")
                        .font(.system(size: 42, weight: .bold))
                }
            }
            .navigationTitle("New Tournament")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Start") {
                        startTournament()
                    }
                    .font(.headline)
                }
            }
            .onAppear {
                viewModel.calculateTournament()
            }
        }
    }
    
    private func startTournament() {
        let newTournament = SavedTournament(
            name: "Tournament \(Date.now.formatted(date: .abbreviated, time: .shortened))",
            players: viewModel.players,
            totalMinutes: viewModel.totalMinutes,
            initialStack: viewModel.calculatedInitialStack,
            startingSmallBlind: viewModel.blindLevels.first?.smallBlind ?? 25,
            blindLevels: viewModel.blindLevels,
            colorUpLevels: viewModel.colorUpLevels
        )
        
        modelContext.insert(newTournament)
        dismiss()
    }
}
