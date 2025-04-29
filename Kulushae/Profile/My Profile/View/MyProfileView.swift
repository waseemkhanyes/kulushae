//
//  MyProfileView.swift
//  Kulushae
//
//  Created by ios on 15/05/2024.
//

import Foundation
import SwiftUI

struct MyProfileView: View {
    
    @StateObject var dataHandler = ProfileViewModel.ViewModel()
    @State var isEditProfileOpen: Bool = false
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationTopBarView(titleVal: "My Profile", isShowBAckButton: true )
            
            VStack(spacing: 0) {
                HStack {
                    //            ZStack(alignment: .bottomTrailing) {
                    AsyncImage(url: URL(string: (Config.imageBaseUrl) + (dataHandler.userObject.image ?? ""))) { image in
                        image
                            .resizable()
                            .frame(width: 100,  height: 100)
                            .cornerRadius(30)
                            .padding(.trailing, 22)
                    } placeholder: {
                        Image("default_property")
                            .frame(width: 100,  height: 100)
                            .cornerRadius(30)
                            .padding(.trailing, 15)
                    }
                    .onAppear() {
                        print("image url is",(Config.imageBaseUrl) + (dataHandler.userObject.image ?? "") )
                    }
                    
                    //                Button(action: {
                    //                    isOpenImageChooseView = true
                    //                }) {
                    //                    Image("camera")
                    //                        .resizable()
                    //                        .foregroundColor(.white)
                    //                        .frame(width: 25, height: 25)
                    //                        .foregroundColor(.blue)
                    //                        .padding(8)
                    //                }
                    //                .background(Color.black)
                    //                .clipShape(
                    //                    RoundedRectangle(cornerRadius: 15)
                    //                )
                    //            }
                    
                    VStack(alignment: .leading) {
                        Spacer()
                        Text((dataHandler.userObject.firstName ?? "" ) + " " +  (dataHandler.userObject.lastName ?? "" ))
                            .font(.roboto_20())
                            .font(.headline.weight(.semibold))
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color.black)
                        
                        HStack(spacing: 1) {
                            Text(LocalizedStringKey("Member Since"))
                                .font(.roboto_14())
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.leading)
                                .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                            Text(" \(dataHandler.userObject.createdAt ?? "")")
                                .font(.roboto_14())
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        Spacer()
                    }
                }
                .frame(height: 100)
                .padding(.top, 35)
                
                        HStack {
                            Spacer()
                            Button(action: {
                                isEditProfileOpen = true
                            }) {
                                Image("pencil")
                
                            }
                        }
                        .padding(.all, 10)
                ScrollView {
                    VStack(spacing: 25) {
                        
                        TextWithImageAndPlaceholderView(image: "icn_@",
                                                        placeholder: "Email",
                                                        value: ($dataHandler.userObject.email))
                        
                        TextWithImageAndPlaceholderView(image: "icn_phone",
                                                        placeholder: "Mobile",
                                                        value: $dataHandler.userObject.phone)
                    }
                }
                        
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        
        .onAppear() {
            if let userId = PersistenceManager.shared.loggedUser?.id {
                dataHandler.getProfileDetails(request:
                                                ProfileViewModel.GetProfileDetailsRequest.Request(
                                                    userId:  Int(userId) ?? -1))
            }
        }
        .navigationBarBackButtonHidden(true)
        .cleanNavigationAndSafeArea()
       
        NavigationLink("", destination: ProfileEditView( dataHandler: dataHandler),
                       isActive: $isEditProfileOpen)
    }
}
