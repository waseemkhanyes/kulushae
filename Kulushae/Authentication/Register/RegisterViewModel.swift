//
//  RegisterViewModel.swift
//  Kulushae
//
//  Created by ios on 10/10/2023.
//

import Foundation
import Apollo
import Firebase
import FirebaseAuth

enum RegisterViewModel {
    // MARK: Use cases
    
    enum MakeRegistrationRequest {
        struct Request: Codable {
            var lastName: String?
            var firstName: String?
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
    
    enum MakeForgotPasswordRequest {
        
        struct Request: Codable {
            var value: String
            var type: String
            var requestFrom: String
        }
        
        struct Response: Codable {
            var success: String?
            var token: String?
        }
    }
    
    class ViewModel: ObservableObject {
        private static let apiHandler = RegisterUserWebService()
        @Published var userObject: RegisterData?
        @Published var errorString: String = ""
        @Published var successString: String = ""
        @Published var isSigningIn: Bool = false
        @Published var isLoading: Bool = false
        @Published var isUserRegistered: Bool = true
        @Published var verificationCode = ""
        @Published var isFromMobile: Bool = false
        @Published var isOTPViewOpen: Bool = false
        @Published var isProfileIncomplete: Bool = false
        
        // call to network functions
        func registerEmailORMobile(request: RegisterViewModel.MakeRegistrationRequest.Request) {
            self.isLoading = true
            ViewModel.apiHandler.registerUsingEmail(request: request) { [weak self] response in
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
                    }
                    
                } else if let errorObject = response.errorMessages {
                    self.errorString = errorObject
                }
            }
            
        }
        
        func checkUserAvailability(request: RegisterViewModel.MakeForgotPasswordRequest.Request) {
            self.isLoading = true
            ViewModel.apiHandler.userAvailabilyEmailOrPhone(request: request) { [weak self] response in
                guard let self = self else { return }
                
                if response.success == "Success" {
                    isUserRegistered = true
                    if request.requestFrom == "register" {
                        errorString = "User already registered with us"
                        self.isLoading = false
                    } else if(request.type == "phone") {
                        sendOtp(number: request.value)
                        UserDefaults.standard.set(response.token, forKey: Keys.Persistance.authKey.rawValue)
                    } else {
                        successString = "Please check your Email for changing the password"
                        self.isLoading = false
                    }
                    
                } else {
                    isUserRegistered = false
                    if request.requestFrom == "register" {
                        sendOtp(number: request.value)
                    } else  {
                        self.isLoading = false
                        errorString = "User not registered with us"
                    }
                }
            }
        }
        
        func sendOtp(number: String) {
            DispatchQueue.main.async {
                PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil) { verificationID, error in
                    if let error = error {
                        self.isLoading = false
                        self.errorString = error.localizedDescription
                        print("Error in verifying phone number:", error.localizedDescription)
                    } else if let verificationID = verificationID {
                        self.verificationCode = verificationID
                        self.isFromMobile = true
                        self.isOTPViewOpen = true
                        self.isLoading = false
                    }
                }
            }
        }
    }
    
}
