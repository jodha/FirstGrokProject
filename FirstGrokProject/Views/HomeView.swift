import SwiftUI
import SwiftData   // ← This was missing

struct HomeView: View {
    @State private var setupVM = TournamentSetupViewModel()
    @State private var showingSetup = false
    
    @Query private var savedTournaments: [SavedTournament]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            List {
                Section("Quick Start") {
                    Button {
                        setupVM.calculateTournament()
                        showingSetup = true
                    } label: {
                        Label("New Tournament", systemImage: "plus.circle.fill")
                            .font(.headline)
                            .foregroundStyle(.blue)
                    }
                }
                
                Section("Saved Tournaments (\(savedTournaments.count))") {
                    if savedTournaments.isEmpty {
                        Text("No saved tournaments yet")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(savedTournaments.sorted(by: { $0.dateCreated > $1.dateCreated })) { tournament in
                            NavigationLink {
                                LiveTournamentView(tournament: tournament)
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(tournament.name)
                                    Text("\(tournament.players) players • \(tournament.totalMinutes) min • Stack: \(tournament.initialStack)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Poker Assistant")
            .sheet(isPresented: $showingSetup) {
                TournamentSetupView(viewModel: setupVM)
            }
        }
    }
}
