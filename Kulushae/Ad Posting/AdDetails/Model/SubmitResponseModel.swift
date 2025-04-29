//
//  SubmitResponseModel.swift
//  Kulushae
//
//  Created by ios on 13/11/2023.
//

import Foundation
import Apollo
import SwiftyJSON

struct UpdateMotorFormResponseModel: Codable {
    
    var message: String?
    var status: String?
}

struct SubmitResponseModel: Codable {
    
    var data: SubmitAddData?
    var errors: [SubmitErrorModel]?
    
    
}

struct UpdatePropertyFormResponseModel: Codable {
    
    var message: String?
    var status: String?
}
struct SubmitAddData: Codable {
    var storeProperty: StoreProperty?
    
}
struct StoreProperty: Codable {
    let status: String?
    let message: String?
    let payment: PaymentModel?
}

struct SubmitErrorModel: Codable {
    var errorFields: [String: String]?
    var message: String?
    var status: String?
    
    init(graphQLError: GraphQLError) {
        self.errorFields = graphQLError["error_fields"] as? [String: String]
        self.status = graphQLError["status"] as? String
        self.message = graphQLError.message
    }
}
// MARK: - Payment
struct PaymentModel: Codable {
    var amount, cart_description, cart_id, country_code, currency_code: String
}
