//
//  BannerModel.swift
//  Kulushae
//
//  Created by Imran-Dev on 04/11/2024.
//

import Foundation

// MARK: - CountryElement
struct BannerModel: Codable , Hashable, Identifiable  {
    
    static func == (lhs: BannerModel, rhs: BannerModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(image)
    }
    let id: Int
    let active_status: Int
    let image : String?
    let type: String?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
            case id, image, type,url
            case active_status = "active_status"
        }
}
