//
//  ChatListWebService.swift
//  Kulushae
//
//  Created by ios on 02/02/2024.
//

import Foundation
import Apollo

class ChatListWebService {
    
    func fetchChatLists(completion: @escaping ([GetChatModel], Error?) -> Void) {
        
        Config.emptyData .createSignature()
        
        Network.shared.apollo.fetch(query: GQLK.GetChatsQuery(), cachePolicy: .fetchIgnoringCacheData) { result in
            
            switch result {
            case .success(let response):
                if let chatDataList = response.data?.getChats {
                    completion(
                        chatDataList.compactMap{ chat in
                            return GetChatModel(id: chat?.id,
                                                receiverID: chat?.receiver_id,
                                                senderID: chat?.sender_id,
                                                categoryID: chat?.category_id,
                                                itemID: chat?.item_id,
                                                property: ChatPropertyData(title: chat?.item?.title ?? "",
                                                                           id: chat?.item?.id ?? 0,
                                                                           image: chat?.item?.image ?? ""),
                                                receiver: ReceiverModel(id: chat?.receiver?.id,
                                                                        first_name: chat?.receiver?.first_name,
                                                                        image: chat?.receiver?.image,
                                                                        last_name: chat?.receiver?.last_name),
                                                sender: ReceiverModel(id: chat?.sender?.id,
                                                                      first_name: chat?.sender?.first_name,
                                                                      image: chat?.sender?.image,
                                                                      last_name: chat?.sender?.last_name),
                                                createdAt: chat?.createdAt,
                                                type: chat?.type ?? ""
                                                
                            )
                        },
                        nil)
                } else {
                    //                    print(response)
                    let error = NSError(domain: "Kulushae", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data in the response."])
                    completion([], error) // Provide nil for the data and an error
                }
            case .failure(let error):
                completion([], error) // Provide nil for the data and the actual error
            }
        }
    }
}
