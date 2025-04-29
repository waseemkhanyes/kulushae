//
//  ChatView.swift
//  Kulushae
//
//  Created by ios on 27/11/2023.
//

import SwiftUI
import Kingfisher

struct ChatView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @StateObject var dataHandler = ChatListViewModel.ViewModel()
    @State var chatId : String = ""
    @State var productId : Int = 0
    @State var receiverId : String = ""
    @State var categoryId: Int = 0
    @State var isOpenChatDetails: Bool = false
    @State var isOpenMotorChatDetails: Bool = false
    @State var selectedChat: GetChatModel? = nil
    
    var body: some View {
        ZStack {
            if dataHandler.chatObjectList.isEmpty {
                VStack(spacing: 0) {
                    NavigationTopBarView(titleVal: "Chat", isShowBAckButton : false)
                    
                    Spacer()
                    
                    Text(LocalizedStringKey("You don't have any messages"))
                        .font(.Roboto.Regular(of: 16))
                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                        .foregroundColor(.black)
                    
                    Spacer()
                }
                
            } else {
                VStack(alignment: .leading) {
                    NavigationTopBarView(titleVal: "Chat", isShowBAckButton : false )
                    
                    ScrollView {
                        LazyVStack {
                            ForEach(dataHandler.chatObjectList, id: \.self) { message in
                                HStack{
                                    ZStack(alignment: .bottomTrailing) {
                                        KFImage(URL(string: Config.imageBaseUrl + (message.property?.image ?? "" )))
                                            .placeholder {
                                                Image("default_property")
                                                    .resizable()
                                                    .frame(width: 81,  height: 81)
                                                    .cornerRadius(25)
                                            }
                                            .resizable()
                                            .frame(width: 81,  height: 81)
                                            .cornerRadius(25)
                                        KFImage(URL(string: Config.imageBaseUrl +
                                                    (((PersistenceManager.shared.loggedUser?.id ?? "") == (message.receiver?.id ?? "")) ? (message.sender?.image ?? "" ) :
                                                        (message.receiver?.image ?? ""))
                                                   ))
                                        .placeholder {
                                            Image("default_property")
                                                .resizable()
                                                .frame(width: 40,  height: 40)
                                                .cornerRadius(20)
                                            //                                                    .offset(x: 15,y: 15)
                                        }
                                        .resizable()
                                        .frame(width: 40,  height: 40)
                                        .cornerRadius(20)
                                        .offset(x: 15,y: 15)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white, lineWidth: 2)
                                                .offset(x: 15,y: 15)
                                        )
                                    }
                                    VStack(alignment: .leading) {
                                        Text(message.property?.title ?? "")
                                            .font(.roboto_22())
                                            .font(.headline.weight(.semibold))
                                            .foregroundColor(Color.black)
                                        Spacer()
                                        Text(((PersistenceManager.shared.loggedUser?.id ?? "") == (message.receiver?.id ?? "")) ? (message.sender?.first_name ?? "" ) :
                                                (message.receiver?.first_name ?? ""))
                                        .font(.roboto_16())
                                        .foregroundColor(Color.gray)
                                        Spacer()
                                        Text(convertUnixTimeToFormattedDate(unixTime: Double(message.createdAt ?? "0.0") ?? 0.0))
                                            .font(.roboto_14())
                                            .foregroundColor(Color.gray)
                                    }
                                    .padding(.leading, 25)
                                    Spacer()
                                }
                                .onTapGesture {
                                    if let userId = PersistenceManager.shared.loggedUser?.id {
                                        if(userId == "\(message.receiverID ?? 0)") {
                                            receiverId = "\(message.senderID ?? 0)"
                                        } else {
                                            receiverId = "\(message.receiverID ?? 0)"
                                        }
                                    }
                                    productId = message.property?.id ?? 0
                                    chatId = message.id ?? ""
                                    categoryId = message.categoryID ?? 0
                                    print("message type", (message.type ?? ""))
                                    selectedChat = message
                                    
                                    if((message.type ?? "").lowercased().contains("motor") ) {
                                        isOpenMotorChatDetails = true
                                    } else {
                                        isOpenChatDetails = true
                                    }
                                    
                                }
                                .frame(height: 85)
                                .padding(.all, 15)
                                .shadow(color: .black.opacity(0.05), radius: 7, x: 0, y: 4)
                            }
                        }
                    }
                    Spacer()
                }
            }
            
        }
        .cleanNavigationAndSafeArea()
        .onAppear() {
            dataHandler.getChatLists()
        }
        NavigationLink("", destination: ChatDetailsView(receiverId: receiverId ,
                                                        categoryId: "\(categoryId)",
                                                        isFromNotification: .constant(true), productId: productId, chatId: chatId, chatFrom: "", chatData: selectedChat),
                       isActive: $isOpenChatDetails)
        
        NavigationLink("", destination: MotorChatViewDetails(receiverId: receiverId ,
                                                             categoryId: "\(categoryId)",
                                                             isFromNotification: .constant(true), productId: productId, chatId: chatId, chatFrom: "", chatData: selectedChat),
                       isActive: $isOpenMotorChatDetails)
    }
}

//#Preview {
//    ChatView()
//}
