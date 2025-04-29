//
//  ChatListViewModel.swift
//  Kulushae
//
//  Created by ios on 02/02/2024.
//

import Foundation
import Apollo

enum ChatListViewModel {
    class ViewModel: ObservableObject {
        
        private static let apiHandler = ChatListWebService()
        
        @Published var isLoading: Bool = false
        @Published var chatObjectList: [GetChatModel] = []
        
        func getChatLists() {
            self.isLoading = true
            ViewModel.apiHandler.fetchChatLists() { [weak self] response, error in
                guard let self = self else { return }
                self.isLoading = false
                self.chatObjectList =   response
                print("cchat count"
                      ,self.chatObjectList.count, response.count)
                print(chatObjectList)
            }
        }
    }
}
