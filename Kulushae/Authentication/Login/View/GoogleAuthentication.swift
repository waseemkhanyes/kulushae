//
//  GoogleAuthentication.swift
//  Kulushae
//
//  Created by ios on 25/04/2024.
//

import Foundation
import Firebase
import GoogleSignIn


class Authentication: ObservableObject {
    
    func googleOauth(completion: @escaping (String, String, String, String) -> Void) async throws {
        // google sign in
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("no firbase clientID found")
        }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        //get rootView
        let scene = await UIApplication.shared.connectedScenes.first as? UIWindowScene
        guard let rootViewController = await scene?.windows.first?.rootViewController
        else {
            fatalError("There is no root view controller!")
        }
        
        //google sign in authentication response
        let result = try await GIDSignIn.sharedInstance.signIn(
            withPresenting: rootViewController
        )
        let user = result.user
        guard let idToken = user.idToken?.tokenString else {
           print( "Unexpected error occurred, please retry")
            return
        }
        
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken, accessToken: user.accessToken.tokenString
        )
        
        let authResult = try await Auth.auth().signIn(with: credential)
        let nameComponents = authResult.user.displayName?.components(separatedBy: " ")
        let fname = nameComponents?.first
        let lname = nameComponents?.last
        completion(authResult.user.uid, authResult.user.email ?? "", fname ?? "",  lname ?? "")
//        
        
        // need to update waseem
        
    }
    
//    func logout() async throws {
//        GIDSignIn.sharedInstance.signOut()
//        try Auth.auth().signOut()
//        do {
//            try await Auth.auth().signOut()
//            authenticationState.isAuthenticated = false
//            authenticationState.user = nil
//        } catch let e {
//            authenticationState.error = e
//        }
//    }
}


extension String: Error {}

