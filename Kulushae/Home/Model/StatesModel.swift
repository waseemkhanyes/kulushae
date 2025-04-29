//
//  StatesModel.swift
//  Kulushae
//
//  Created by ios on 08/06/2024.
//

import Foundation

// MARK: - StatesModelElement
struct StatesModelElement: Codable {
    let id: Int?
    let name: String?
    let translation: String?
    let countryID: Int?
    let state_code: String?
    let latitude: Double?
    let longitude: Double?

    enum CodingKeys: String, CodingKey {
        case id, name, translation, state_code, latitude, longitude
        case countryID = "country_id"
    }
}

typealias StatesModel = [StatesModelElement]
