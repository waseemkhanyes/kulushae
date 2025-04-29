//
//  ChatWebServices.swift
//  Kulushae
//
//  Created by ios on 17/01/2024.
//

import Foundation
import Alamofire

class ChatWebService {
    
    func sendMessages(serviceType: String, type: String, message: String, itemData: PropertyData , receiverID: String, chat_id: String,   completion: @escaping (String, Error?) -> Void) {
        let params: [String: String] = [
            "sender_id": PersistenceManager.shared.loggedUser?.id ?? "",
            "receiver_id": receiverID,
            "type": type,
            "item_id": "\(itemData.id ?? 0)" ,
            "category_id": "\(itemData.categoryID ?? 0)" ,
            "message": message,
            "chat_id" : chat_id,
            "service_type"  : serviceType
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("chat json",jsonString )
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                        if let chatId = jsonObject["chat_id"] as? Int {
                            print("Chat ID: \(chatId)")
                        }
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
        } catch {
            print("Error converting parameters to JSON string: \(error)")
        }
        
        RestAPINetworkManager.shared.postRequest(url: Config.baseURL + Config.pusherSentMessage,
                                                 parameters: params
        ) { result in
            switch result {
            case .success(let data):
                // Handle successful response
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Bool]
                    print(json)
                } catch {
                    print("Error parsing JSON: \(error)")
                }
                
               
            case .failure(let error):
                // Handle error
                print("Error: \(error)")
            }
        }
    }
    
    func sendMotorMessages(serviceType: String, type: String, message: String, itemData: PostedCars , receiverID: String, chat_id: String,   completion: @escaping (String, Error?) -> Void) {
        let params: [String: String] = [
            "sender_id": PersistenceManager.shared.loggedUser?.id ?? "",
            "receiver_id": receiverID,
            "type": type,
            "item_id": "\(itemData.id ?? 0)" ,
            "category_id": "\(itemData.categoryID ?? 0)" ,
            "message": message,
            "chat_id" : chat_id,
            "service_type"  : serviceType
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("chat json",jsonString )
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                        if let chatId = jsonObject["chat_id"] as? Int {
                            print("Chat ID: \(chatId)")
                        }
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
        } catch {
            print("Error converting parameters to JSON string: \(error)")
        }
        
        RestAPINetworkManager.shared.postRequest(url: Config.baseURL + Config.pusherSentMessage,
                                                 parameters: params
        ) { result in
            switch result {
            case .success(let data):
                // Handle successful response
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Bool]
                    print(json)
                } catch {
                    print("Error parsing JSON: \(error)")
                }
                
               
            case .failure(let error):
                // Handle error
                print("Error: \(error)")
            }
        }
    }
    
    static func getCurrentDate() -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        
        return dateFormatter.string(from: Date())
        
    }
    
    func fetchOldChatLists(senderId: Int, catId: Int, itemId: Int, receiverId: Int, chatId: Int, completion: @escaping ([ChatMessage]?, Error?) -> Void) {
        
        let jsonObject: [String: Any?] = [
            "chatId" : chatId,
            "senderId": senderId,
            "receiverId": receiverId,
            "categoryId": catId,
            "itemId": itemId
        ].removeNullValues
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.sortedKeys]) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("old chat request", Config.emptyData + jsonString)
                (Config.emptyData + jsonString).createSignature()
            }
        }
        Network.shared.apollo.fetch(
            query: GQLK.GetMessagesQuery(
                chatId: chatId.graphQLNullable,
                senderId: senderId.graphQLNullable,
                receiverId: receiverId.graphQLNullable,
                categoryId: catId.graphQLNullable,
                itemId: itemId.graphQLNullable
            ),
            cachePolicy: .fetchIgnoringCacheData
        ) { result in
            switch result {
            case .success(let response):
                if let messages = response.data?.getMessages {
                    let userId = PersistenceManager.shared.loggedUser?.id ?? ""
                    let messageList: [ChatMessage] = messages.compactMap { message in
                        return ChatMessage(
                            receiverID: (userId == "\(message?.receiver_id ?? 0)") ? message?.sender_id ?? 0 :  message?.receiver_id,
                            senderID: message?.sender_id,
                            chatID: message?.chat_id,
                            type: message?.type,
                            message: message?.message,
                            createdAt: convertUnixTimeToFormattedDate(unixTime: Double(message?.createdAt ?? "") ?? 0.0) ,
                            isSender: (Int(userId) ?? 0) != message?.receiver_id
                        )
                    }
                    completion(messageList, nil)
                } else {
                                        print(response)
                    let error = NSError(domain: "Kulushae", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data in the response."])
                    completion([], error) // Provide nil for the data and an error
                }
            case .failure(let error):
                print(error)
                completion([], error) // Provide nil for the data and the actual error
            }
        }
    }
    
}
