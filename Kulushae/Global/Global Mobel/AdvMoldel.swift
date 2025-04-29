//
//  AdvMoldel.swift
//  Kulushae
//
//  Created by ios on 12/04/2024.
//

struct AdvModel: Codable, Hashable, Equatable {
    static func == (lhs: AdvModel, rhs: AdvModel) -> Bool {
        return lhs.id == rhs.id
    }
    let id: Int?
    let image, title: String?
    let type: String?
    let userID: Int?
}
