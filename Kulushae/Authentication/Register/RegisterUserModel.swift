//
//  RegisterUserModel.swift
//  Kulushae
//
//  Created by ios on 10/10/2023.
//

import Foundation

// MARK: - RegisterUserModel
struct RegisterUserModel: Codable {
    let data: RegisterUserDataClass?
    let errors: [APIError]?
}

// MARK: - DataClass
struct RegisterUserDataClass: Codable {
    let register: RegisterData
}

// MARK: - Register
struct RegisterData: Codable {
    let email, id, firstName, lastName, image, phone: String?

    enum CodingKeys: String, CodingKey {
        case email, id, image, phone
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
