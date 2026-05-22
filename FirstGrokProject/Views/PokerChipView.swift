import SwiftUI

struct PokerChipView: View {
    let color: Color
    let label: String

    var body: some View {
        ZStack {
            chipBody
            Text(label)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.primary)
        }
        .shadow(color: .black.opacity(0.4), radius: 4, x: 2, y: 2)
    }

    private var chipBody: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [color.opacity(0.9), color],
                        center: .center,
                        startRadius: 2,
                        endRadius: 40
                    )
                )
            Circle()
                .strokeBorder(Color.white, lineWidth: 4)
            Circle()
                .strokeBorder(Color.white.opacity(0.6), lineWidth: 1)
                .padding(3)
        }
        .frame(width: 56, height: 56)
    }
}
