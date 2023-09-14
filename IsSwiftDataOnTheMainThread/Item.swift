//
//  Item.swift
//  IsSwiftDataOnTheMainThread
//
//  Created by Pol Piella Abadia on 14/09/2023.
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
