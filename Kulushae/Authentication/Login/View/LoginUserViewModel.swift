//
//  LoginUserViewModel.swift
//  Kulushae
//
//  Created by ios on 13/10/2023.
//

import Foundation
import Apollo

enum LoginUserViewModel {
    // MARK: Use cases
    
    enum MakeLoginUserRequest {
        
        struct Request: Codable {
            var email: String?
            var password: String?
            var phone: String?
            var type: String
            var id: String?
        }
        
        struct Response: Codable {
            var userObject: RegisterData?
            var error: Bool
            var errorMessages: String?
            var token: String
            var refreshToken: String
        }
    }
    
    class ViewModel: ObservableObject {
        private static let apiHandler = LoginUserWebService()
        @Published var userObject: RegisterData?
        @Published var errorString: String = ""
        @Published var isSigningIn: Bool = false
        @Published var isLoading: Bool = false
        @Published var isProfileIncomplete: Bool = false
        
        // call to network functions
        func loginEmail(request: LoginUserViewModel.MakeLoginUserRequest.Request) {
            self.isLoading = true
            ViewModel.apiHandler.LoginUsingEmailORPhone(request: request) { [weak self] response in
                guard let self = self else { return }
                self.isLoading = false
                
                if let validUserRegistrationResponse = response.userObject {
                    self.isSigningIn = response.errorMessages == nil
                    self.userObject = validUserRegistrationResponse
                    if(self.isSigningIn) {
                        PersistenceManager.shared.userStates = UserStateManager(currentAuthState: .loggedIn,
                                                                                currentOnboardingState: .onBoardedAndLanguageSelected)
                        UserDefaults.standard.set(response.token, forKey: Keys.Persistance.authKey.rawValue)
                        UserDefaults.standard.set(response.refreshToken, forKey: Keys.Persistance.refreshToken.rawValue)
                        UserDefaults.standard.synchronize()
                        if let isProfileComplete =  UserDefaults.standard.value(forKey: Keys.Persistance.isUserInfoFilled.rawValue) as? Bool  {
                            isProfileIncomplete = isProfileComplete
                        }
                    }
                    
                } else if let errorObject = response.errorMessages {
                    self.errorString = errorObject
                }
            }
             
        }
    }
    
}
