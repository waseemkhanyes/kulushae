//
//  CategoryListModel.swift
//  Kulushae
//
//  Created by ios on 17/10/2023.
//


import Foundation

// MARK: - Category
struct CategoryModelElement: Codable {
    let data: CategoryDataClass
}

// MARK: - DataClass
struct CategoryDataClass: Codable {
    let categories: [CategoryListModel]?
}

// MARK: - CategoryElement
struct CategoryListModel: Codable, Hashable, Identifiable  {

    static func == (lhs: CategoryListModel, rhs: CategoryListModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        // Handle optional title field consistently
        hasher.combine(title ?? "")
    }

    let id: String
    let image, parentID: String?
    let title: String?
    var active_for_listing: Bool?
    var has_child: Bool?
    var has_form: Bool
    var service_type: String?
    var bgColor: String?

    enum CodingKeys: String, CodingKey {
        case id, image
        case parentID = "parent_id"
        case title
        case active_for_listing
        case has_child
        case has_form
        case service_type
        case bgColor
    }
}
