import SwiftUI

struct LiveTournamentLevelHeaderView: View {
    let currentLevel: Int
    let blindLevel: BlindLevel?

    var body: some View {
        VStack {
            Text("Level \(currentLevel)")
                .font(.largeTitle)
                .fontWeight(.bold)
            blindAmounts
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(16)
    }

    @ViewBuilder
    private var blindAmounts: some View {
        if let level = blindLevel {
            HStack(spacing: 40) {
                blindColumn(amount: level.smallBlind, label: "Small Blind")
                blindColumn(amount: level.bigBlind, label: "Big Blind")
            }
        }
    }

    private func blindColumn(amount: Int, label: String) -> some View {
        VStack {
            Text("\(amount)")
                .font(.system(size: 48, weight: .bold))
            Text(label)
                .font(.caption)
        }
    }
}
