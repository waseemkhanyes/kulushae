//
//  ProfileViewModel.swift
//  Kulushae
//
//  Created by ios on 30/11/2023.
//

import Foundation
import Apollo

enum ProfileViewModel {
    enum GetProfileDetailsRequest {
        
        struct Request: Codable {
            var userId: Int
        }
        
        struct Response: Codable {
            var userData: UserIDModel
        }
    }
    
    enum GetUserAds {
        struct Request: Codable {
            var userId: Int
            var page: Int
        }
        
        struct Response: Codable {
            var advObject: [AdvModel]
            var total: Int
            var per_page: Int
        }
    }
    
    enum DeleteUserDetailsRequest {
        
        struct Response: Codable {
            var isSuccess: Bool
        }
    }
    
    enum UpdateUserDetailsRequest {
        
        struct Request: Codable {
            var userId: Int
            var image:String?
            var fName: String?
            var lName: String?
            var phone: String?
            var email: String?
        }
        
        struct Response: Codable {
            var isSuccess: Bool
        }
    }
    
    class ViewModel: ObservableObject {
        
        private static let apiHandler = ProfileWebService()
        
        @Published var isLoading: Bool = false
        @Published var userObject: UserIDModel =  UserIDModel(id: nil, image: nil, firstName: nil, lastName: nil, email: nil, phone: nil, member_since: nil, total_listings: nil, createdAt: nil)
        @Published var isUserDeleted = false
        @Published var advObject: [AdvModel] = []
        @Published var totalPageCount: Int = 1
        @Published var totalAdvCount: Int = 1
        
        func getProfileDetails(request: ProfileViewModel.GetProfileDetailsRequest.Request) {
            self.isLoading = true
            ViewModel.apiHandler.fetchProfileDetails(user_id: request.userId) { [weak self] response, error in
                guard let self = self else { return }
                self.isLoading = false
                if let userResponse = response {
                    self.userObject =   userResponse.userData
                }
            }
        }
        
        func deleteUser() {
            ViewModel.apiHandler.deleteUserProfile() { [weak self] response, error in
                guard let self = self else { return }
                if let success = response {
                    if(success) {
                        print("properties deleted")
                    }
                }
            }
        }
        
        func deleteProperties(idList: [GQLK.DeleteItem]) {
            ViewModel.apiHandler.deletePostedAds(ids: idList) { [weak self] response, error in
                guard let self = self else { return }
                if let success = response {
                    if(success) {
                        isUserDeleted = true
                    }
                }
            }
        }
        
        func getAds(userId: Int, page: Int) {
            if(page == 1) {
                self.advObject = []
            }
            ViewModel.apiHandler.listMyAds(id: userId, page: page) { [weak self] response, error in
                guard let self = self else { return }
                if let advResponse = response {
                    totalAdvCount = Int(round(Double(advResponse.total)))
                    totalPageCount = Int(round(Double(advResponse.total / advResponse.per_page)))
                    self.advObject =   self.advObject + advResponse.advObject
                    self.isLoading = false
                }
            }
        }
        
        
        func updateUser(request: ProfileViewModel.UpdateUserDetailsRequest.Request) {
            self.isLoading = true
            ViewModel.apiHandler.updateUserProfile(request: request) { [weak self] response, error in
                guard let self = self else { return }
                if let success = response {
                    if(success) {
                        ViewModel.apiHandler.fetchProfileDetails(user_id: request.userId) { [weak self] response, error in
                            guard let self = self else { return }
                            if let userResponse = response {
                                self.userObject =   userResponse.userData
                                PersistenceManager.shared.loggedUser = RegisterData(email: userResponse.userData.email, id: userResponse.userData.id, firstName: userResponse.userData.firstName, lastName: userResponse.userData.firstName, image: userResponse.userData.image, phone: userResponse.userData.phone)
                                if let fName = userResponse.userData.firstName,
                                   let email = userResponse.userData.email {
                                    if( fName.isEmpty ||  (email.isEmpty)) {
                                        UserDefaults.standard.set(false, forKey: Keys.Persistance.isUserInfoFilled.rawValue)
                                    } else {
                                        UserDefaults.standard.set(true, forKey: Keys.Persistance.isUserInfoFilled.rawValue)
                                    }
                                    
                                } else {
                                    UserDefaults.standard.set(false, forKey: Keys.Persistance.isUserInfoFilled.rawValue)
                                }
                                
                                UserDefaults.standard.synchronize()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    self.isLoading = false
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
}
