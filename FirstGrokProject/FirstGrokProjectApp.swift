import SwiftUI
import SwiftData

@main
struct FirstGrokProjectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: SavedTournament.self)
    }
}