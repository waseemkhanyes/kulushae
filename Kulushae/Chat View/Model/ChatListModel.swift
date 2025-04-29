//
//  ChatListModel.swift
//  Kulushae
//
//  Created by ios on 02/02/2024.
//

import Foundation

// MARK: - ChatListModel
struct ChatListModel: Codable {
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    let getChats: [GetChatModel]?
}

// MARK: - GetChat
struct GetChatModel: Codable, Identifiable, Hashable {
    
    static func == (lhs: GetChatModel, rhs: GetChatModel) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: String?
    let receiverID, senderID, categoryID, itemID: Int?
    let property: ChatPropertyData?
    let receiver: ReceiverModel?
    let sender: ReceiverModel?
    let createdAt: String?
    let type: String?

    enum CodingKeys: String, CodingKey {
        case id
        case receiverID = "receiver_id"
        case senderID = "sender_id"
        case categoryID = "category_id"
        case itemID = "item_id"
        case property, receiver, createdAt, sender,type
    }
}

// MARK: - Receiver
struct ReceiverModel: Codable {
    let id, first_name, image, last_name: String?

    enum CodingKeys: String, CodingKey {
        case id
        case first_name
        case image
        case last_name
    }
}

struct ChatPropertyData: Codable {
    let title: String?
    let id: Int?
    let image: String?

    enum CodingKeys: String, CodingKey {
        case title
        case id
        case image
    }
}
