//
//  ZendeskMessagingViewController.swift
//  Kulushae
//
//  Created by ios on 23/04/2024.
//

import SwiftUI
import ZendeskSDKMessaging
import ZendeskSDK

struct ZendeskMessagingViewController: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        guard let viewController = Zendesk.instance?.messaging?.messagingViewController() else {
            return UIViewController()
        }
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update the view controller if needed
    }
    
    typealias UIViewControllerType = UIViewController
}

