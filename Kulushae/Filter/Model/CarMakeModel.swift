//
//  CarMakeModel.swift
//  Kulushae
//
//  Created by ios on 12/05/2024.
//

import Foundation

struct CarMakeModel: Codable {
    let data: CarMakeDataClass?
}

// MARK: - CarMakeDataClass
struct CarMakeDataClass: Codable {
    let motorMakes: [MotorMake]?

    enum CodingKeys: String, CodingKey {
        case motorMakes = "motor_makes"
    }
}

// MARK: - MotorMake
struct MotorMake: Codable {
    let id, title, image: String
}
