//
//  CountryModel.swift
//  Kulushae
//
//  Created by ios on 16/05/2024.
//

import Foundation

// MARK: - CountryElement
struct KulushaeCountry: Codable , Hashable, Identifiable  {
    
    static func == (lhs: KulushaeCountry, rhs: KulushaeCountry) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(iso3)
    }
    let id: Int
    let activeForListing: Int
    let iso3, iso2, name, translation: String?
    let currency: String?
    let emoji: String?
    
    enum CodingKeys: String, CodingKey {
            case id, name, translation, iso3, iso2, currency, emoji
            case activeForListing = "active_for_listing"
        }
}
