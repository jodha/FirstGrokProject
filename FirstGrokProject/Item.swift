//
//  Item.swift
//  FirstGrokProject
//
//  Created by Urvashi Bhardwaj on 5/11/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
