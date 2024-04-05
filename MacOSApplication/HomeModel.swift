//
//  HomeModel.swift
//  MacOSApplication
//
//  Created by Vivek Patel on 18/03/24.
//

import Foundation
// MARK: - DataClass
struct RecentModel: Codable, Hashable {
    var name: String?
    var isSelected: Bool?
    enum CodingKeys: String, CodingKey {
        case name
        case isSelected
    }
}
