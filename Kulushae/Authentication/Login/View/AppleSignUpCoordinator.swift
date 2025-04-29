//
//  AppleSignUpCoordinator.swift
//  Kulushae
//
//  Created by ios on 25/04/2024.
//

import Foundation
import SwiftUI
import AuthenticationServices

class UserSettings: ObservableObject {
    // 1 = Authorized, -1 = Revoked
    @Published var authorization: Int = 0
}


class AppleSignUpCoordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    var parent: SignUpWithAppleView?
    
    init(_ parent: SignUpWithAppleView) {
        self.parent = parent
        super.init()
        
    }
    
    @objc func didTapButton() {
        //Create an object of the ASAuthorizationAppleIDProvider
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        //Create a request
        let request         = appleIDProvider.createRequest()
        //Define the scope of the request
        request.requestedScopes = [.fullName, .email]
        //Make the request
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        
        //Assingnig the delegates
        authorizationController.presentationContextProvider = self
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let vc = UIApplication.shared.windows.last?.rootViewController
        return (vc?.view.window!)!
    }
    
    //If authorization is successfull then this method will get triggered
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credentials = authorization.credential as? ASAuthorizationAppleIDCredential else {
            print("credentials not found....")
            return
        }
        
        //Storing the credential in user default for demo purpose only deally we should have store the credential in Keychain
        let defaults = UserDefaults.standard
        defaults.set(credentials.user, forKey: "userId")
        print("namename", credentials.fullName ?? "")
        parent?.name = "\(credentials.fullName?.givenName ?? "")"
        print("Apple ID Credential: \(credentials.identityToken)")
    }
    
    //If authorization faced any issue then this method will get triggered
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
        //If there is any error will get it here
        print("Error In Credential")
    }
}
