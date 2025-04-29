import Foundation
import PusherSwift
import SwiftyJSON

struct PusherAuthResponse: Codable {
    let auth: String
}

enum ChatViewModel {
    
    class ViewModel: ObservableObject, PusherDelegate {
        
        static let shared = ChatViewModel.ViewModel()
        private static let apiHandler = ProfileWebService()
        private static let chatApiHandler = ChatWebService()
        
        @Published var messages: [ChatMessage] = []
        @Published var senderURL: String = ""
        @Published var receiverURL: String = ""
        @Published var isLoading: Bool = false
        @Published var isMessageUploaded: Bool = false
        @Published var chatIdVal: String = ""
        
        var isFirstCall = false
        var channelName = ""
        
        func setupPusher(senderId: String, catId: String, itemId: String, receiverId: String) {
            
            let channelName = "private-chat_channel-\(catId)\(itemId)\(senderId)\(receiverId)"
            self.channelName = channelName
            if !PusherManager.shared.isSubscribed(channelName: channelName) {
                print("channel name",channelName )
                PusherManager.shared.subscribeToChannel(channelName: channelName, eventName: "chat", userId: senderId) { [weak self] event in
                    guard var jsonString = event.data else {
                        print("Received invalid data format. Expected String.")
                        return
                    }
                    jsonString = jsonString.replacingOccurrences(of: "\n", with: "")
                    jsonString = jsonString.replacingOccurrences(of: "\r", with: "")
                    jsonString = jsonString.replacingOccurrences(of: "\t", with: "")
                    
                    if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
                        do {
                            let json = try JSON(data: dataFromString)
                            if(senderId == receiverId) {
                                if(self?.senderURL == "") {
                                    if let userID =  Int(senderId) {
                                        self?.setSenderProfile(userID: userID, isSender: true)
                                    }
                                }
                            } else {
                                if(self?.receiverURL == "") {
                                    if let userID =  Int(receiverId) {
                                        self?.setSenderProfile(userID: userID, isSender: false)
                                    }
                                }
                            }
                            let messageData = ChatMessage(
                                receiverID: Int(receiverId) ?? 0,
                                senderID: Int(senderId) ?? 0,
                                chatID: Int(self?.chatIdVal ?? "0"),
                                type: json["type"].stringValue,
                                message: json["message"].stringValue,
                                createdAt: convertUnixTimeToFormattedDate(unixTime: Double(json["createdAt"].stringValue) ?? 0.0) ,
                                isSender: senderId == receiverId
                            )
                            self?.messages.append(messageData)
                        } catch {
                            // Handle the error here
                            print("Error decoding JSON data: \(error)")
                        }
                    }
                }
            }
           
        }
        
        func disconnectPusher() {
            PusherManager.shared.disconnect()
        }
        
        func chennelDisconnect(_ name: String) {
            PusherManager.shared.unSubscribeChannel(name)
        }
        
        func sentMessage(serviceType: String, type: String,message: String, itemData: PropertyData, receiverId: String, chatId: String) {
            ViewModel.chatApiHandler.sendMessages(serviceType: serviceType, type: type, message: message, itemData: itemData, receiverID: receiverId, chat_id: chatId)  { [weak self] response, error in
                guard let self = self else { return }
                self.isMessageUploaded = true
            }
            if(senderURL == "") {
                let id  = PersistenceManager.shared.loggedUser?.id ?? ""
                if let userID =  Int(id){
                    setSenderProfile(userID: userID, isSender: true)
                }
            }
        }
        func sentMotorMessage(serviceType: String, type: String,message: String, itemData: PostedCars, receiverId: String, chatId: String) {
            ViewModel.chatApiHandler.sendMotorMessages(serviceType: serviceType, type: type, message: message, itemData: itemData, receiverID: receiverId, chat_id: chatId)  { [weak self] response, error in
                guard let self = self else { return }
                self.isMessageUploaded = true
            }
            if(senderURL == "") {
                let id  = PersistenceManager.shared.loggedUser?.id ?? ""
                if let userID =  Int(id){
                    setSenderProfile(userID: userID, isSender: true)
                }
            }
        }
        
        func getOldChatMessages(senderId: String, catId: String, itemId: String, receiverId: String, chatId: Int?) {
            self.isLoading = true
            ViewModel.chatApiHandler.fetchOldChatLists(senderId: Int(senderId) ?? 0,
                                                       catId: Int(catId) ?? 0,
                                                       itemId: Int(itemId) ?? 0,
                                                       receiverId:Int(receiverId) ?? 0,
                                                       chatId: chatId ?? 0) { [weak self] response, error in
                guard let self = self else { return }
                self.isLoading = false
                if let chatResponse = response {
                    self.messages =   chatResponse
                    for message  in self.messages {
                        if let chatID = message.chatID {
                            chatIdVal = "\(chatID)"
                        }
                        if(message.isSender) {
                            if(senderURL == "") {
                                if let userID =  message.senderID {
                                    setSenderProfile(userID: userID, isSender: true)
                                }
                            }
                        } else {
                            if(receiverURL == "") {
                                if let userID =  message.receiverID {
                                    setSenderProfile(userID: userID, isSender: false)
                                }
                            }
                        }
                    }
                    
                }
            }
        }
        
        func setSenderProfile(userID: Int, isSender: Bool) {
            ViewModel.apiHandler.fetchProfileDetails(user_id: userID) { [weak self] response, error in
                print("** wk userID: \(userID)")
                if let userResponse = response {
                    DispatchQueue.main.async {
                        if(isSender) {
                            self?.senderURL =  Config.imageBaseUrl +  (userResponse.userData.image ?? "")
                        } else{
                            self?.receiverURL =  Config.imageBaseUrl +  (userResponse.userData.image ?? "")
                        }
                    }
                    
                }
            }
        }
        
    }
}
