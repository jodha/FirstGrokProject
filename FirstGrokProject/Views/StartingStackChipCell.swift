import SwiftUI

struct StartingStackChipCell: View {
    let chip: ChipDenomination

    var body: some View {
        VStack(spacing: 8) {
            chipImage
            countLabel
            subtotalLabel
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private var chipImage: some View {
        PokerChipView(
            color: ChipColorMapper.color(for: chip.value),
            label: "$\(chip.value)"
        )
    }

    private var countLabel: some View {
        Text("×\(chip.count)")
            .font(.headline)
    }

    private var subtotalLabel: some View {
        Text("$\(chip.value * chip.count)")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
}
