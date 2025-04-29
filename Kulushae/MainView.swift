//
//  MainView.swift
//  Kulushae
//
//  Created by ios on 13/01/2024.
//

import Foundation
import SwiftUI
import Combine

struct MainView: View {
    @State private var selectedTab = 0
    @State var isTabViewVisible = true
    @State var isLoginOpen : Bool = false
    @State var isUserInfoOpen : Bool = false
    @EnvironmentObject var languageManager: LanguageManager
    //    @State var isCityChosen = false
    
    @State private var showSupportChat = false
    
    func goHome() {
        isTabViewVisible = true
        selectedTab = 0
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                switch selectedTab {
                case 0:
                    //                    HomeView(isLoginSheetPresented: $isLoginOpen,isCityChosen: $isCityChosen)
//                    HomeView(isLoginSheetPresented: $isLoginOpen)
                    HomeViewNew(isLoginSheetPresented: $isLoginOpen)
                case 1:
                    FavoriteView(goHome: goHome)
                case 2:
                    AdsView(goHome: goHome)
                case 3:
                    ChatView()
                case 4:
                    ProfileView()
                default:
                    EmptyView()
                }
                if(isTabViewVisible) {
                    HStack {
                        Button(action: {
                            isTabViewVisible = true
                            self.selectedTab = 0
                        }) {
                            Image(self.selectedTab == 0 ? "icn_home_filled": "icn_home")
                        }
                        .frame(maxWidth: .infinity)
                        
                        Button(action: {
                            if(!isLoggedUser()) {
                                DispatchQueue.main.async {
                                    isLoginOpen = true
                                    isTabViewVisible = true
                                    self.selectedTab = 0
                                }
                            }
                             if(isLoggedUser() && isProfileComplete()) {
                                isTabViewVisible = true
                                self.selectedTab = 1
                            } else {
                                if(!isProfileComplete()) {
                                    DispatchQueue.main.async {
                                        isUserInfoOpen = true
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        isLoginOpen = true
                                        isTabViewVisible = true
                                        self.selectedTab = 0
                                    }
                                }
                            }
                        }) {
                            Image(self.selectedTab == 1 ? "icn_fav_filled": "icn_fav")
                            
                        }
                        .frame(maxWidth: .infinity)
                        
                        Button(action: {
                            if(PersistenceManager.shared.userStates?.currentAuthState == .loggedIn) {
                                isTabViewVisible = false
                                self.selectedTab = 2
                            } else {
                                DispatchQueue.main.async {
                                    isLoginOpen = true
                                    isTabViewVisible = true
                                    self.selectedTab = 0
                                }
                            }
                        }) {
                            Image("icn_placeAd")
                                .foregroundColor(self.selectedTab == 2 ? .black : .gray)
                                .opacity(isTabViewVisible ? 1 : 0)
                                .disabled(!isTabViewVisible)
                                .frame(maxWidth: .infinity, maxHeight: 50)
                                .padding(.vertical, 5)
                                .offset(y: -10)
                        }
                        .frame(maxWidth: .infinity)
                        
                        Button(action: {
                            
                            if(PersistenceManager.shared.userStates?.currentAuthState == .loggedIn) {
                                isTabViewVisible = true
                                self.selectedTab = 3
                            } else {
                                DispatchQueue.main.async {
                                    isLoginOpen = true
                                    isTabViewVisible = true
                                    self.selectedTab = 0
                                }
                            }
                        }) {
                            Image(self.selectedTab == 3 ? "icn_chat_filled": "icn_chat")
                        }
                        .frame(maxWidth: .infinity)
                        
                        Button(action: {
                            
                            if(PersistenceManager.shared.userStates?.currentAuthState == .loggedIn) {
                                isTabViewVisible = true
                                self.selectedTab = 4
                            } else {
                                DispatchQueue.main.async {
                                    isLoginOpen = true
                                    isTabViewVisible = true
                                    self.selectedTab = 0
                                }
                            }
                        }) {
                            Image(self.selectedTab == 4 ? "icn_profile_filled": "icn_profile")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .opacity(isTabViewVisible ? 1 : 0)
                    .disabled(!isTabViewVisible)
                    .foregroundColor(.clear)
                    .frame(width: .screenWidth, height: 86)
                    .background(isTabViewVisible ? Color(red: 0.96, green: 0.96, blue: 0.96) : Color.appBackgroundColor)
                    .cornerRadius(20)
                    .shadow(color: isTabViewVisible ?  .black.opacity(0.05) : .white, radius: 23, x: 0, y: 4)
                    
                    .overlay(){
                        if(!isLoginOpen) {
                            HStack {
                                Spacer()
                                Button(action: {
                                    print("Floating button tapped!")
                                    showSupportChat = true
                                }) {
                                    Image(languageManager.currentLanguage == "ar" ? "chat_floating_ar": "chat_floating")
                                        
                                        .foregroundColor(.white)
                                }
                            }
                            .offset( y: -60)
                        }
                    }
                    
                }
                
                //                .padding(.bottom, 5)
                //            .overlay(
                //                Button(action: {
                //                    if(PersistenceManager.shared.userStates?.currentAuthState == .loggedIn) {
                //                        isTabViewVisible = false
                //                        self.selectedTab = 2
                //                    } else {
                //                        withAnimation {
                //                            isTabViewVisible = true
                //                            self.selectedTab = 0
                //                        }
                //                    }
                //                }) {
                //                    Image(uiImage: UIImage(named: "icn_placeAd") ?? UIImage())
                //                        .resizable()
                //                        .frame(width: 80, height: 80)
                //                }
                //                    .opacity(isTabViewVisible ? 1 : 0)
                //                    .disabled(!isTabViewVisible)
                //            )
            }
            //            .onReceive(Just(isCityChosen)) { chosen in
            //                isTabViewVisible = !chosen && self.selectedTab != 2
            //            }
            .sheet(isPresented: $showSupportChat) {
                ZendeskMessagingViewController()
            }
//            .sheet(isPresented: $isUserInfoOpen) {
//                MissingProfileInfoView()
//            }
            NavigationLink("", destination: MissingProfileInfoView(),
                               isActive: $isUserInfoOpen
                           )
        }
        .ignoresSafeArea()
    }
    
    func isProfileComplete() -> Bool {
        return UserDefaults.standard.value(forKey: Keys.Persistance.isUserInfoFilled.rawValue) as? Bool  ?? true
    }
    func isLoggedUser() -> Bool {
        return PersistenceManager.shared.userStates?.currentAuthState == .loggedIn
    }
}
