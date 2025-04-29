//
//  PostedCarModel.swift
//  Kulushae
//
//  Created by ios on 29/03/2024.
//

import Foundation

// MARK: - PostedCarModel
struct PostedCarModel: Codable {
    let data: PostedCarData?
}

// MARK: - DataClass
struct PostedCarData: Codable {
    let motors: Motors?
}

// MARK: - Motors
struct Motors: Codable {
    let currentPage, perPage, total: String?
    let data: [PostedCars]?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case perPage = "per_page"
        case total, data
    }
}

// MARK: - Datum
struct PostedCars: Codable , Hashable, Identifiable  {
    
    static func == (lhs: PostedCars, rhs: PostedCars) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
    }
    let id: Int?
    let emirates, make, model,  trim, specs: String?
    let year, kilometers: String?
    let insuredInUae: Bool?
    let price: Double?
    let contactInfo, title, desc: String?
    let tourURL: String?
    let fuelType, exteriorColor, interiorColor: String?
    let warranty: String?
    let doors, noOfCylinders, transmissionType: String?
    let bodyType: String?
    let seatingCapacity, horsepwer: String?
    let engineCapacity: String?
    let steeringSide, seller: String?
    let extras: [Extra]?
    var images: [ImageModel]?
    var isFavorite: Bool?
    var type: String?
    var userID: UserIDModel?
    let categoryID: Int?
    let makeId: Int?
    let modelId: Int?
    let isNew: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, emirates
        case trim, specs, year, kilometers
        case insuredInUae = "insured_in_uae"
        case price
        case contactInfo = "contact_info"
        case title, desc
        case make, model
        case tourURL = "tour_url"
        case fuelType = "fuel_type"
        case exteriorColor = "exterior_color"
        case interiorColor = "interior_color"
        case warranty, doors
        case noOfCylinders = "no_of_cylinders"
        case transmissionType = "transmission_type"
        case bodyType = "body_type"
        case seatingCapacity = "seating_capacity"
        case horsepwer,type
        case engineCapacity = "engine_capacity"
        case steeringSide = "steering_side"
        case seller, extras, images
        case isFavorite = "is_favorite"
        case userID = "user_id"
        case categoryID = "category_id"
        case makeId = "make_id"
        case modelId = "model_id"
        case isNew = "is_new"
    }
}

// MARK: - Extra
struct Extra: Codable {
    let id, title: String?
}
