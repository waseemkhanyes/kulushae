//
//  FavouriteModel.swift
//  Kulushae
//
//  Created by ios on 16/04/2024.
//

import Foundation
struct FavouriteModel: Codable , Hashable, Equatable {
    static func == (lhs: FavouriteModel, rhs: FavouriteModel) -> Bool {
        return lhs.id == rhs.id
    }
    let id: Int?
    let image: String?
    let size: String?
    let location, title, type: String?
    let userID: Int?
    let bathrooms, bedrooms: String?
    let price: String?
    let carYear: String?
    let carSteering, carSpecs: String?
    let carKilometers: String?

    enum CodingKeys: String, CodingKey {
        case id, image, size, location, title, type
        case userID = "user_id"
        case bathrooms, bedrooms, price
        case carYear = "car_year"
        case carSteering = "car_steering"
        case carSpecs = "car_specs"
        case carKilometers = "car_kilometers"
    }
}
