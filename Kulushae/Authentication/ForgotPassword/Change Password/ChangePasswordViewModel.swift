//
//  ChangePasswordViewModel.swift
//  Kulushae
//
//  Created by ios on 23/10/2023.
//

import Foundation
import Apollo

enum ChangePasswordViewModel {
    // MARK: Use cases
    
    enum MakeChangePasswordRequest {
        
        struct Request: Codable {
            var password: String
        }
        
        struct Response: Codable {
            var error: Bool?
            var status: String?
            var message: String?
        }
    }
    
    class ViewModel: ObservableObject {
        private static let apiHandler = ChangePasswordWebService()
        @Published var status: String = ""
        @Published var error: Bool = false
        @Published var isLoading: Bool = false
        @Published var successString: String = ""
        @Published var errorString: String = ""
        // call to network functions
        func changePassword(request: ChangePasswordViewModel.MakeChangePasswordRequest.Request) {
            self.isLoading = true
            ViewModel.apiHandler.changeUserPassword(request: request) { [weak self] response in
                guard let self = self else { return }
                self.isLoading = false
                
                if let changePasswordResponse = response.status,
                   changePasswordResponse == "success" {
                    successString =  response.message ?? "Password updated successfully"
                } else  {
                    self.error = true
                    self.errorString = "Something went wrong, please try again later"
                }
            }
             
        }
    }
    
}

