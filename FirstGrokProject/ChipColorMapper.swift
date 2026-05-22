import SwiftUI

enum ChipColorMapper {

    static func colorIndex(for denomination: Int) -> Int {
        switch denomination {
        case 25: return 0
        case 100: return 1
        case 500: return 2
        case 1000: return 3
        case 5000: return 4
        default: return 9
        }
    }

    static func color(for denomination: Int) -> Color {
        ChipColors.color(for: colorIndex(for: denomination))
    }
}
