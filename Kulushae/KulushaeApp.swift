//
//  KulushaeApp.swift
//  Kulushae
//
//  Created by ios on 07/10/2023.
//

import SwiftUI
import Firebase
import Alamofire
import ZendeskSDKMessaging
import ZendeskSDK
import GoogleSignIn // need to update waseem

@main
struct KulushaeApp: App {
    @State private var isUpdateAvailable = false
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var isFlipped = false
    @StateObject private var languageManager = LanguageManager()
    @State private var isFirstLaunch: Bool = true
    @State var isChatDetailsOpen: Bool = false
    @State var isOpenMotorChatDetails: Bool = false
    @State var isProductDetailsOpen: Bool = false
    @State var notificationData: [String: String] = [:]
    @State private var productID: String = "-1"
    @State private var productType: String = ""

    init() {
        PersistenceManager.shared.loadCountryAndStateFromUserDefaults()
        PersistenceManager.shared.loadCountryForAddPostsFromUserDefaults()
        
        Zendesk.initialize(withChannelKey: Config.zendeskChatKey,
                           messagingFactory: DefaultMessagingFactory()) { result in
            if case let .failure(error) = result {
                print("Messaging did not initialize.\nError: \(error.localizedDescription)")
            }
            Zendesk.instance?.logoutUser { result in
                switch result {
                case .success:
                    print("Chat cleared and user logged out successfully.")
                case .failure(let error):
                    print("Failed to clear chat and logout user. Error: \(error.localizedDescription)")
                }
            }
        }
    }
    var body: some Scene {
        WindowGroup {
            if isFirstLaunch {
                if isProductDetailsOpen {
                    if productType.lowercased().contains("property") {
                        PostedAdDetailsView(productId: Int(productID) ?? 1, isFromShareLink: true,  onDismiss: {
                                            isProductDetailsOpen = false
                                        })
                    }
                    if productType.lowercased().contains("motors") {
                        CarDetailsView(motorId: Int(productID) ?? 1, isFromShareLink: true,  onDismiss: {
                            isProductDetailsOpen = false
                        })
                    }
                } else {
                    VideoPlayerContainer(isFirstLaunch: $isFirstLaunch)
                        .onDisappear {
                            // Ensure that the NavigationLink to HomeView is triggered when VideoPlayerContainer disappears
                            DispatchQueue.main.async {
                                UserDefaults.standard.set(true, forKey: "isFirstLaunch")
                                isFirstLaunch = false
                            }
                        }
                }
            } else {
                NavigationView {
                    if isProductDetailsOpen {
                        if productType.lowercased().contains("property") {
                            PostedAdDetailsView(productId: Int(productID) ?? 1, isFromShareLink: true,  onDismiss: {
                                                isProductDetailsOpen = false
                                            })
                        }
                        if productType.lowercased().contains("motors") {
                            CarDetailsView(motorId: Int(productID) ?? 1, isFromShareLink: true,  onDismiss: {
                                isProductDetailsOpen = false
                            })
                        }
                    }
                    if isChatDetailsOpen || isOpenMotorChatDetails {
                        if let productId = notificationData["item_id"],
                           let receiverId = notificationData["sender_id"],
                           let catId = notificationData["category_id"],
                           let chatId = notificationData["chat_id"] {
                            if isChatDetailsOpen {
                                ChatDetailsView(receiverId: receiverId,
                                                categoryId: catId,
                                                isFromNotification: $isChatDetailsOpen,
                                                productId: Int(productId) ?? 0,
                                                chatId: chatId,
                                                chatFrom: "")
                            } else if isOpenMotorChatDetails {
                                MotorChatViewDetails(receiverId: receiverId,
                                                    categoryId: catId,
                                                    isFromNotification: $isOpenMotorChatDetails,
                                                     productId: Int(productId) ?? 0,
                                                     chatId: chatId,
                                                     chatFrom: "")
                            }
                        }
                    } else {
                        MainView()
                            .onOpenURL { url in
                                isFirstLaunch = false
                                // Handle Google OAuth URL
                                GIDSignIn.sharedInstance.handle(url) // need to update waseem
                                // Handle Universal Links
                                handleUniversalLink(url: url)
                            }
                            .navigationBarHidden(true)
                    }
                    
                    //                    HomeView()
                    
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .environmentObject(languageManager)
                .environment(\.layoutDirection, languageManager.layoutDirection)
                
                .rotation3DEffect(
                    .degrees(isFlipped ? 180 : 0),
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                )
                .onAppear {
                    checkForUpdate()
                    if let authKey = UserDefaults.standard.string(forKey: Keys.Persistance.authKey.rawValue) {
                        let headers: HTTPHeaders = ["Authorization": "Bearer \(authKey)"]
                        RestAPINetworkManager.shared.getRequest(url: Config.baseURL + Config.verifyToken, headers: headers) { result in
                            switch result {
                            case .success(let data):
                                // Handle successful response
                                do {
                                    // Parse the JSON data
                                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                        // Extract the 'verified' value
                                        if let verified = json["verified"] as? Bool {
                                            if(!verified) {
                                                reFreshToken()
                                            }
                                        } else {
                                            print("Verified key not found or not a Bool")
                                        }
                                    } else {
                                        print("Failed to cast JSON as dictionary")
                                    }
                                } catch {
                                    print("Error parsing JSON: \(error)")
                                }
                                
                                print("Data received: \(data)")
                            case .failure(let error):
                                // Handle error
                                print("Error: \(error)")
                            }
                        }
                    }
                }
                .onAppear() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        if let storedInfo = UserDefaults.standard.dictionary(forKey: "chatNotificationInfo") as? [String: String] {
                            notificationData = storedInfo
//                            print("sdfvrvr", notificationData)
                            isChatDetailsOpen = true
                            UserDefaults.standard.removeObject(forKey: "chatNotificationInfo")
                            UserDefaults.standard.synchronize()
                        }
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ChatNotificationTapped"))) { notification in
                    notificationData =  notification.userInfo as? [String: String] ?? [:]
                    print("** wk notificationData: \(notificationData)")
                    DispatchQueue.main.async() {
                        UserDefaults.standard.removeObject(forKey: "chatNotificationInfo")
                        UserDefaults.standard.synchronize()
                    }
                    let serviceType = trim(notificationData["service_type"])
                    if serviceType == "motors" {
                        isOpenMotorChatDetails = true
                    } else if serviceType == "property" {
                        isChatDetailsOpen = true
                    }
                    
                }
                .onReceive(NotificationCenter.default.publisher(for: .navigateToProductDetails)) { notification in
                    if let url = notification.object as? URL {
                        handleUniversalLink(url: url)
                    }
                }
            }
        }
    }

    func handleUniversalLink(url: URL) {
        let pathComponents = url.pathComponents
        if pathComponents.count > 2 {
            let productType = pathComponents[1]
            let productID = pathComponents[2]
            self.productType = productType
            self.productID = productID
            if productType.lowercased().contains("motor") || productType.lowercased().contains("property") {
                isProductDetailsOpen = true
            }
        }
    }

    func reFreshToken() {
        if let refreshAuthKey = UserDefaults.standard.string(forKey: Keys.Persistance.refreshToken.rawValue) {
            let refreshHeaders: HTTPHeaders = [
                "X-Refresh-Token": refreshAuthKey
            ]
            RestAPINetworkManager.shared.postRequest(url: Config.baseURL + Config.refreshToken, headers: refreshHeaders) { result in
                switch result {
                case .success(let data):
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String],
                           let refreshToken = json["refresh_token"], let token = json["token"] {
                            UserDefaults.standard.set(token, forKey: Keys.Persistance.authKey.rawValue)
                            UserDefaults.standard.set(refreshToken, forKey: Keys.Persistance.refreshToken.rawValue)
                        }
                    } catch {
                        PersistenceManager.shared.logout()
                        print("Error parsing JSON: \(error)")
                    }
                case .failure:
                    PersistenceManager.shared.logout()
                }
            }
        }
    }

    private func checkForUpdate() {
           guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
               return
           }

           guard let url = URL(string: "https://itunes.apple.com/lookup?bundleId=com.cashgatetechnologies.Kulushae") else {
               return
           }

           let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
               if let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let results = json["results"] as? [[String: Any]],
                  let appStoreVersion = results.first?["version"] as? String {
                   
                   if compareVersions(currentVersion, appStoreVersion) == .orderedAscending {
                       DispatchQueue.main.async {
                           isUpdateAvailable = true
                       }
                   }
               }
           }
           task.resume()
       }

       private func compareVersions(_ version1: String, _ version2: String) -> ComparisonResult {
           return version1.compare(version2, options: .numeric)
       }

       private func openAppStore() {
           if let url = URL(string: "appStoreLink") {
               UIApplication.shared.open(url, options: [:], completionHandler: nil)
           }
       }
}

