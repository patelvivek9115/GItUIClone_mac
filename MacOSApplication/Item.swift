//
//  Item.swift
//  MacOSApplication
//
//  Created by Vivek Patel on 14/03/24.
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
