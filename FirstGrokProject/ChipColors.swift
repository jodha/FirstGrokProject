import SwiftUI

enum ChipColors {
    static let standard: [Color] = [
        Color(white: 0.95),
        Color.red,
        Color.green,
        Color.blue,
        Color(white: 0.15),
        Color.purple,
        Color.yellow,
        Color.orange,
        Color.pink,
        Color.gray
    ]

    static func color(for index: Int) -> Color {
        guard index >= 0, index < standard.count else { return .gray }
        return standard[index]
    }
}
