//
//  PostedAdvModel.swift
//  Kulushae
//
//  Created by ios on 16/11/2023.
//

import Foundation

// MARK: - PostedAdvModel
struct PostedAdvModel: Codable {
    let data: PostedAdvData?
}

// MARK: - DataClass
struct PostedAdvData: Codable {
    let properties: PostedAdProperties?
}

// MARK: - Properties
struct PostedAdProperties: Codable {
    let data: [PropertyData]?
    let currentPage, perPage, total: String?
    
    enum CodingKeys: String, CodingKey {
        case data
        case currentPage = "current_page"
        case perPage = "per_page"
        case total
    }
}

// MARK: - Property
struct PropertyData: Codable, Hashable, Identifiable  {
    
    static func == (lhs: PropertyData, rhs: PropertyData) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
    }
    let id: Int?
    let title, contactNumber, description_val: String?
    let socialmedia: [SocialmediaModel]?
    let size, bedrooms, bathrooms: String?
    let amenities: [AmenityModel]?
    var userID: UserIDModel?
    let neighbourhood, location: String?
    let categoryID: Int?
    var images: [ImageModel]?
    let price: Double?
    let isFeatured: Bool?
    var isFavorite: Bool?
    let type: String?
    let youtube_url: String?
    let three_sixty_url: String?
    let country: String?
    let emirates: String?
    let deposit: Int?
    let referenceNumber: String?
    let developer: String?
    let readyBy: String?
    let anualCommunityFee: String?
    let furnished: Bool?
    let totalClosingFee: String?
    let buyerTransferFee: String?
    let sellerTransferFee: String?
    let maintenanceFee: String?
    let occupancyStatus: String?
    let postedBy: String?

    enum CodingKeys: String, CodingKey {
        case id, title
        case contactNumber = "contact_number"
        case socialmedia, size, bedrooms, bathrooms, amenities
        case userID = "user_id"
        case neighbourhood, location
        case categoryID = "category_id"
        case images, price,type
        case description_val = "description"
        case isFeatured = "is_featured"
        case isFavorite = "is_favorite"
        case youtube_url, three_sixty_url
        case deposit, country, emirates
        case referenceNumber = "reference_number"
        case developer
        case readyBy = "ready_by"
        case anualCommunityFee = "annual_community_fee"
        case furnished
        case totalClosingFee = "total_closing_fee"
        case buyerTransferFee = "buyer_transfer_fee"
        case sellerTransferFee = "seller_transfer_fee"
        case maintenanceFee = "maintenance_fee"
        case occupancyStatus = "occupancy_status"
        case postedBy = "posted_by"
    }
}

// MARK: - Amenity
struct AmenityModel: Codable, Hashable {
    let id, title: String?
}

// MARK: - Image
struct ImageModel: Codable, Hashable {
    let id, image: String?
}

// MARK: - Socialmedia
struct SocialmediaModel: Codable {
    let id: String?
    let type: String?
    let value: String?
}


// MARK: - UserID
struct UserIDModel: Codable, Equatable {
    let id: String?
    var image: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var phone: String?
    let member_since: String?
    let total_listings: Int?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case image = "imag"
        case firstName = "first_name"
        case lastName = "last_name"
        case email, phone, member_since, total_listings, createdAt
    }
}

