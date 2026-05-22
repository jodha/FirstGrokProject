import SwiftUI

struct StartingStackDisplayView: View {
    let totalStackValue: Int
    let recommendedStack: [ChipDenomination]

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        Section("Recommended Starting Stack per Player") {
            VStack(spacing: 16) {
                headerCard
                chipGrid
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
        }
    }

    private var headerCard: some View {
        VStack(spacing: 4) {
            Text("Per player")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text("$\(totalStackValue)")
                .font(.system(size: 36, weight: .bold))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }

    private var chipGrid: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(recommendedStack) { chip in
                StartingStackChipCell(chip: chip)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
}
