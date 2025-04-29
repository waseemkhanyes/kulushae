//
//  SearchModel.swift
//  Kulushae
//
//  Created by ios on 26/02/2024.
//

import Foundation
// MARK: - Search
struct SearchModel: Codable, Hashable {
    let ads: Int?
    let category: String?
    let categoryID: Int?
    let propertyTitle: String?
    let type: String?

    enum CodingKeys: String, CodingKey {
        case ads, category
        case categoryID = "category_id"
        case propertyTitle = "title"
        case type
    }
}
