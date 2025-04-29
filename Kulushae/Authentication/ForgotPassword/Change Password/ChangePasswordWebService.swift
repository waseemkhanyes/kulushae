//
//  ChangePasswordWebService.swift
//  Kulushae
//
//  Created by ios on 23/10/2023.
//

import Foundation
import Apollo

class ChangePasswordWebService {
    
    func changeUserPassword(request: ChangePasswordViewModel.MakeChangePasswordRequest.Request,
                            completion: @escaping (ChangePasswordViewModel.MakeChangePasswordRequest.Response) -> Void = { _ in })
    {
        let jsonObject: [String: Any?] = [
            "password" : request.password
        ].removeNullValues
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.sortedKeys]) {
            // Step 1: Convert the JSON object to a string
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("change password params", Config.emptyData + jsonString)
                (Config.emptyData + jsonString).createSignature()
            }
        }
        
        Network.shared.apollo.perform(mutation: GQLK.UpdatePasswordMutation(password: request.password)) { result in
            UserDefaults.standard.set("", forKey: Keys.Persistance.authKey.rawValue)
            UserDefaults.standard.synchronize()
            switch result {
                
            case .success(let graphQLResult):
                if let result = graphQLResult.data?.updatePassword {

                    let response = ChangePasswordViewModel.MakeChangePasswordRequest.Response(error: false, status: result.status, message: result.message)
                    completion(response)
                } else if let errors = graphQLResult.errors {
                    // Handle errors
                    let response = ChangePasswordViewModel.MakeChangePasswordRequest.Response(error: true,status: "failed", message: "something went wrong")
                    completion(response)
                }
            case .failure(let error):
                // Handle the network error
                let response = ChangePasswordViewModel.MakeChangePasswordRequest.Response(error: true,status: "failed", message: "something went wrong")
                completion(response)
            }
        }
    }
}
