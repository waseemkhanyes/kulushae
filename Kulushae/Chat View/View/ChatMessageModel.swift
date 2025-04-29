//
//  ChatMessageModel.swift
//  Kulushae
//
//  Created by ios on 11/01/2024.
//
//
//import Foundation
//
//struct ChatMessage: Codable, Identifiable, Equatable {
//    var id = UUID()
//    let senderId: String?
//    let receiverId: String?
//    let message: String?
//    let createdAt: String?
//    let isSender: Bool
//}

import Foundation

// MARK: - ChatListModel
struct ChatMessageModel: Codable {
    let data: ChatDataClass?
}
// MARK: - DataClass
struct ChatDataClass: Codable {
    let getMessages: [ChatMessage]?
}

// MARK: - GetMessage
struct ChatMessage: Codable, Identifiable, Equatable, Hashable {
    let id = UUID()
    let receiverID, senderID, chatID: Int?
    let type, message, createdAt: String?
    var isSender: Bool

    enum CodingKeys: String, CodingKey {
        case receiverID = "receiver_id"
        case senderID = "sender_id"
        case chatID = "chat_id"
        case type, message, createdAt, isSender
    }
}
