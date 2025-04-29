//
//  CarModels.swift
//  Kulushae
//
//  Created by ios on 13/05/2024.
//

import Foundation

// MARK: - CarModels
struct CarModels: Codable {
    let data: CarModelsDataClass?
}

// MARK: - DataClass
struct CarModelsDataClass: Codable {
    let motorModels: [MotorModel]?
    
    enum CodingKeys: String, CodingKey {
        case motorModels = "motor_models"
    }
}

// MARK: - MotorModel
struct MotorModel: Codable {
    let id: String?
    let motorMakeID: Int?
    let title: String?
    let image: String?

    enum CodingKeys: String, CodingKey {
        case id
        case motorMakeID = "motor_make_id"
        case title
        case image
    }
}
