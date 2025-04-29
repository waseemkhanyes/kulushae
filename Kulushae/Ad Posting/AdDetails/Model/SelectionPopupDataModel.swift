//
//  SelectionPopupDataModel.swift
//  Kulushae
//
//  Created by ios on 07/11/2023.
//

import Foundation

// MARK: - SelectionPopupDataModel
struct SelectionPopupDataModel: Codable {
    let data: PopUpDataClass
}

// MARK: - DataClass
struct PopUpDataClass: Codable {
    let amenities: [AmenityList]
}

// MARK: - Amenity
struct AmenityList: Codable, Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
    }
    
    let id, title: String
}
