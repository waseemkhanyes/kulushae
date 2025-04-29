//
//  SupportView.swift
//  Kulushae
//
//  Created by ios on 21/04/2024.
//

import SwiftUI
import ZendeskCoreSDK
import SupportSDK

struct ZendeskSupportViewController: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @SwiftUI.State var name: String
    @SwiftUI.State var email: String
    
    func makeUIViewController(context: Context) -> UIViewController {
        var viewController = UIViewController()
        Zendesk.instance?.setIdentity(Identity.createAnonymous(name: name, email: email))
        let requestListScreen = RequestUi.buildRequestList(with: [])
        
        viewController = requestListScreen
        
        return UINavigationController(rootViewController: viewController)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update logic if needed
    }
    
    class Coordinator: NSObject {
        var parent: ZendeskSupportViewController
        
        init(_ parent: ZendeskSupportViewController) {
            self.parent = parent
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
}
