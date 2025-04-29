//
//  APIError.swift
//  Kulushae
//
//  Created by ios on 10/10/2023.
//

import Foundation

// MARK: - APIError
struct APIErrorModel: Codable {
    let errors: [APIError]
}

// MARK: - Error
struct APIError: Codable {
    let message, status: String
}
