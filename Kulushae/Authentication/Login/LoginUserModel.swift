//
//  LoginUserModel.swift
//  Kulushae
//
//  Created by ios on 10/10/2023.
//

import Foundation

// MARK: - LoginModel
struct LoginModel: Codable {
    let data: LoginDataClass
    let errors: [APIError]?
}

// MARK: - DataClass
struct LoginDataClass: Codable {
    let login: Login
}

// MARK: - Login
struct Login: Codable {
    let message, status, token: String?
    let user: RegisterData
}

