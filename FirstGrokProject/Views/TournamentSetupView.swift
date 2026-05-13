import SwiftUI
import SwiftData

struct TournamentSetupView: View {
    @Bindable var viewModel: TournamentSetupViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            Form {
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
                
                Section("Your Available Chips") {
                    ForEach(viewModel.chipDenominations.indices, id: \.self) { index in
                        HStack {
                            Text("$\(viewModel.chipDenominations[index].value)")
                                .font(.title3)
                            Spacer()
                            Stepper("\(viewModel.chipDenominations[index].count)",
                                   value: $viewModel.chipDenominations[index].count,
                                   in: 0...100)
                        }
                    }
                }
                
                Section("Recommended Starting Stack per Player") {
                    Text("Total Value: $\(viewModel.totalStackValue)")
                        .font(.headline)
                    
                    ForEach(viewModel.recommendedStack) { chip in
                        HStack {
                            Text("$\(chip.value)")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Spacer()
                            Text("\(chip.count) chips")
                                .font(.title3)
                        }
                    }
                }
            }
            .navigationTitle("New Tournament")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Start Tournament") {
                        startTournament()
                    }
                    .font(.headline)
                }
            }
            .onAppear {
                viewModel.calculateTournament()
            }
            .onChange(of: viewModel.players) { _ in
                viewModel.calculateTournament()
            }
            .onChange(of: viewModel.totalMinutes) { _ in
                viewModel.calculateTournament()
            }
            .onChange(of: viewModel.chipDenominations) { _ in
                viewModel.calculateTournament()
            }
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
            colorUpLevels: viewModel.colorUpLevels
        )
        
        modelContext.insert(newTournament)
        dismiss()
    }
}
