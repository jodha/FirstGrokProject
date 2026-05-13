import SwiftUI
import SwiftData

@main
struct FirstGrokProjectApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: SavedTournament.self)
    }
}

