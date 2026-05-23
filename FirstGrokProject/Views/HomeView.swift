import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var setupVM = TournamentSetupViewModel()
    @State private var showingSetup = false
    @State private var reuseTournament: SavedTournament? = nil
    
    @Query private var savedTournaments: [SavedTournament]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("GreenFelt")
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
                    .opacity(0.85)
                
                List {
                    Section("Quick Start") {
                        Button {
                            setupVM = TournamentSetupViewModel() // fresh
                            showingSetup = true
                        } label: {
                            Label("New Tournament", systemImage: "plus.circle.fill")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .shadow(radius: 2)
                        }
                        .listRowBackground(Color.black.opacity(0.3))
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
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                        Text("\(tournament.players) players • \(tournament.totalMinutes) min • Stack: $\(tournament.initialStack)")
                                            .font(.caption)
                                            .foregroundStyle(.white.opacity(0.8))
                                    }
                                }
                                .swipeActions(edge: .trailing) {
                                    Button {
                                        reuseTournament = tournament
                                        showingSetup = true
                                    } label: {
                                        Label("Reuse", systemImage: "arrow.clockwise")
                                    }
                                    .tint(.blue)
                                }
                                .listRowBackground(Color.black.opacity(0.3))
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Poker Assistant")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .sheet(isPresented: $showingSetup) {
                if let reuse = reuseTournament {
                    TournamentSetupView(viewModel: TournamentSetupViewModel(from: reuse))
                } else {
                    TournamentSetupView(viewModel: setupVM)
                }
            }
            .onChange(of: showingSetup) { _, newValue in
                if !newValue {
                    reuseTournament = nil // reset after closing
                }
            }
        }
    }
}
