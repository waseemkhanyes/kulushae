//
//  PusherManager.swift
//  Kulushae
//
//  Created by ios on 19/01/2024.
//


import Foundation
import PusherSwift
import SwiftyJSON
import UserNotifications

class PusherManager {
    static let shared = PusherManager()
    
    private let pusher: Pusher
    
    private var subscribedChannels: Set<String> = []
    
    private init() {
        self.pusher = Pusher(key: Config.pusherKey, options: PusherClientOptions(
            authMethod: .endpoint(authEndpoint: Config.baseURL + Config.pusherAuthURL),
            host: .cluster(Config.pusherCluster)))
        pusher.connect()
    }
    
    func subscribeToChannel(channelName: String, eventName: String, userId: String, completion: @escaping (PusherEvent) -> Void) {
        pusher.connect()
        let channel = pusher.subscribe(channelName)
        print("Subscribed to channel: \(channelName)")
        subscribedChannels.insert(channelName)
        
        channel.bind(eventName: eventName) { (event: PusherEvent) in
            if(eventName == "global") {
                self.displayLocalNotification(for: event)
            }
            completion(event)
            
        }
        
        
    }
    func isSubscribed(channelName: String) -> Bool {
        // Check if the channel is in the set of subscribed channels
        return subscribedChannels.contains(channelName)
    }
    
    func disconnect() {
        pusher.disconnect()
    }
    func unSubscribeAll() {
        pusher.unsubscribeAll()
    }
    func unSubscribeChannel(_ name: String) {
        pusher.unsubscribe(name)
        let newChan = Array(subscribedChannels)
        subscribedChannels = Set(newChan.filter({$0 != name}))
    }
    func displayLocalNotification(for event: PusherEvent) {
        // Ensure this method is executed on the main thread
        DispatchQueue.main.async {
            
            guard var jsonString = event.data else {
                print("Received invalid data format. Expected String.")
                return
            }
            if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
                do {
                    let json = try JSON(data: dataFromString)
                    let content = UNMutableNotificationContent()
                    content.title = "Pusher Event Received"
                    content.body = "Chat: \(json["message"].stringValue))"
                    content.sound = UNNotificationSound.default
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    
                    
                    UNUserNotificationCenter.current().add(request)
                }
                catch {
                    // Handle the error here
                    print("Error decoding JSON data: \(error)")
                }
            }
            
        }
    }
    
}
