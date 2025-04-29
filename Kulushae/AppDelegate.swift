//
//  AppDelegate.swift
//  Kulushae
//
//  Created by ios on 16/10/2023.
//

import UIKit
import Foundation
import FirebaseAuth
import FirebaseCore
import IQKeyboardManagerSwift
import Stripe
import UserNotifications
//import AppCenter
//import AppCenterAnalytics
//import AppCenterCrashes
import Firebase
import FirebaseMessaging
import SwiftUI
import Alamofire
import ZendeskCoreSDK
import SupportSDK
import GoogleSignIn // need to update waseem
import FBSDKCoreKit
import IQKeyboardManagerSwift
import IQKeyboardToolbarManager


class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        
//        IQKeyboardManager.shared.isEnabled = true
//        IQKeyboardManager.shared.enableAutoToolbar = true
//        IQKeyboardToolbarManager.shared.isEnabled = true

        
//        IQKeyboardManager.shared.isEnabled = true
//        IQKeyboardManager.shared.enableToolbarDebugging = true
//        IQKeyboardManager.shared.resignOnTouchOutside = true
//        IQKeyboardManager.shared.toolbarConfiguration.tintColor = .blue // need to update waseem
        //        StripeAPI.defaultPublishableKey = "pk_live_51Mt3E0KZUmMf7YmN4hzzxFDevEbGqkDDdlu1nXILW9u91oUL5oLbLlhF2fOlGVUcIyzO5vpSdoGBbPogaI9zUJWj0039Vl4nZM"
        StripeAPI.defaultPublishableKey = "pk_test_51Mt3E0KZUmMf7YmNt3eVvGlyHyzkN2khXD1zU4EhU8PT82yvoQ1OlVDdFO2IuGungCGbtlQR6TJxVA6gs9vqj8Si00IVghjEdZ"
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if granted {
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                    }
                }
            }
        application.registerForRemoteNotifications()
//        AppCenter.start(withAppSecret: "8de5cf08-479a-448b-9ca4-432ab5c4157d", services:[
//            Analytics.self,
//            Crashes.self
//        ])
        FBSDKCoreKit.ApplicationDelegate.shared.application(
                    application,
                    didFinishLaunchingWithOptions: launchOptions
                )
        Zendesk.initialize(appId: Config.zenDeskAppID, clientId: Config.zenDeskClientId, zendeskUrl: Config.zendeskUrl)
            Support.initialize(withZendesk: Zendesk.instance)
        
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardToolbarManager.shared.isEnabled = true
        
        return true
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration tokenFirebase registration token: \(String(describing: fcmToken))")
        DispatchQueue.main.async {
            UserDefaults.standard.set(fcmToken ?? "", forKey: Keys.Persistance.fcmToken.rawValue)
            UserDefaults.standard.synchronize()
        }
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        if let savedFCMToken = UserDefaults.standard.value(forKey: Keys.Persistance.fcmToken.rawValue) as? String {
            if(fcmToken != savedFCMToken) {
                updateFCMToken()
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Handle the notification
        print("Received notification:", userInfo)
        
        if let aps = userInfo["aps"] as? [String: Any],
           let alert = aps["alert"] as? [String: Any],
           let bodyString = alert["data"] as? [String: String] {
            
            if let notificationType = bodyString["notification_type"], notificationType == "chat" {
                userTappedNotification(chatDic: bodyString)
            }
        }

        completionHandler(.newData)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Handle device token registration
        Messaging.messaging().apnsToken = deviceToken
        print("Device Token:", deviceToken)
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        let userInfo = notification.request.content.userInfo
        completionHandler(.banner)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle the notification tap
        let notification = response.notification
        let userInfo = notification.request.content.userInfo
        
        print("Notification tapped.")
        if let aps = userInfo["aps"] as? [String: Any],
           let alert = aps["alert"] as? [String: Any],
           let bodyString = alert["data"] as? [String: String] {
            if let notificationType = bodyString["notification_type"] {
                if notificationType == "chat" {
                    userTappedNotification(chatDic: bodyString)
                }
            }
        }
        completionHandler()
    }
    
//    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
//          guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
//                let url = userActivity.webpageURL else {
//              return false
//          }
//
//          NotificationCenter.default.post(name: .navigateToProductDetails, object: url)
//          return true
//      }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        // Handle continued user activity here
        print("aaaaaa")
        return true
    }
    
    func updateFCMToken() {
        let params: Parameters = [
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "user_id": PersistenceManager.shared.loggedUser?.id ?? "",
            "fcm_token": UserDefaults.standard.value(forKey: Keys.Persistance.fcmToken.rawValue) as? String ?? ""
        ]
        
        RestAPINetworkManager.shared.postRequest(url: Config.baseURL + Config.refreshFCMToken,
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
                
                print("Data received: \(data)")
            case .failure(let error):
                // Handle error
                print("Error: \(error)")
            }
        }
    }
    
    func userTappedNotification(chatDic: [String: String]) {
//        // Post a notification or handle the navigation here
        if (UIApplication.shared.applicationState == .active) {
                // App is in the foreground, handle the notification tap
                NotificationCenter.default.post(name: Notification.Name("ChatNotificationTapped"), object: nil, userInfo: chatDic)
        } else {
            NotificationCenter.default.post(name: Notification.Name("ChatNotificationTapped"), object: nil, userInfo: chatDic)
            UserDefaults.standard.set(chatDic, forKey: "chatNotificatiChatNotificationTappedonInfo")
        }
       
//        NotificationCenter.default.post(name: Notification.Name("ChatNotificationTapped"), object: nil, userInfo: chatDic)
    }
    
}

extension Notification.Name {
    static let navigateToProductDetails = Notification.Name("navigateToProductDetails")
}
