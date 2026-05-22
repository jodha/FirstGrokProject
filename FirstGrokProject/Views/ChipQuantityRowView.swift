import SwiftUI

struct ChipQuantityRowView: View {
    let denomination: Int
    @Binding var count: Int
    let onCountChange: () -> Void
    @State private var countText: String = ""

    var body: some View {
        HStack(spacing: 12) {
            PokerChipView(
                color: ChipColorMapper.color(for: denomination),
                label: chipLabel
            )
            Text(chipLabel)
                .font(.headline)
            Spacer()
            TextField("0", text: $countText)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.trailing)
                .frame(width: 72)
                .textFieldStyle(.roundedBorder)
                .onChange(of: countText) { _, newValue in
                    applyText(newValue)
                }
        }
        .onAppear { countText = String(count) }
    }

    private var chipLabel: String {
        "$\(denomination)"
    }

    private func applyText(_ text: String) {
        let parsed = Int(text.filter { $0.isNumber }) ?? 0
        let clamped = min(max(parsed, 0), 999)
        count = clamped
        countText = String(clamped)
        onCountChange()
    }
}
