//
//  LoginUserWebService.swift
//  Kulushae
//
//  Created by ios on 10/10/2023.
//

import Foundation
import Apollo
import UIKit

class LoginUserWebService {
    
    func LoginUsingEmailORPhone(request: LoginUserViewModel.MakeLoginUserRequest.Request,
                                completion: @escaping (LoginUserViewModel.MakeLoginUserRequest.Response) -> Void = { _ in })
    {
        
        var email = request.email
        if let nEmail = email {
            email = nEmail.lowercased()
        }
        
        let jsonObject: [String: Any?] = [
            "email" : email,
            "password": request.password,
            "phone": request.phone,
            "fcmToken": UserDefaults.standard.value(forKey: Keys.Persistance.fcmToken.rawValue) as? String,
            "deviceId": UIDevice.current.identifierForVendor!.uuidString,
            "deviceType": "ios",
            "deviceMake": "apple",
            "deviceModel": UIDevice.current.model,
            "deviceVersion": UIDevice.current.systemVersion,
            "loginId": request.id,
            "type": request.type,
        ].removeNullValues
        print("** wk apple signIn jsonObject: \(jsonObject)")
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.sortedKeys]) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("login code generate key: \(Config.emptyData)")
                print("login password params", Config.emptyData + jsonString)
                (Config.emptyData + jsonString).createSignature()
            }
        }
        
        
        
        Network.shared.apollo.perform(
            mutation: GQLK.LoginMutation(
                fcmToken: (UserDefaults.standard.value(forKey: Keys.Persistance.fcmToken.rawValue) as? String)?.graphQLNullable ?? nil,
                deviceId: UIDevice.current.identifierForVendor!.uuidString.graphQLNullable,
                deviceType: "ios",
                deviceMake: "apple",
                
                deviceModel: UIDevice.current.model.graphQLNullable,
                deviceVersion: UIDevice.current.systemVersion.graphQLNullable,
                loginId: request.id?.graphQLNullable ?? nil,
                type: request.type.graphQLNullable,
                phone: request.phone?.graphQLNullable ?? nil,
                email: email?.graphQLNullable ?? nil,
                password: request.password?.graphQLNullable ?? nil
            )
        ) { result in
             
            switch result {
                
            case .success(let graphQLResult):
                if let user = graphQLResult.data?.login?.user {
                    // Handle the user data
                    let userData = RegisterData(email: user.email, id: user.id, firstName: user.first_name, lastName: user.last_name, image: user.image, phone: user.phone)
                    let response = LoginUserViewModel.MakeLoginUserRequest.Response(userObject: userData, error: false, token: graphQLResult.data?.login?.token ?? "", refreshToken: graphQLResult.data?.login?.refresh_token ?? "")
                    print("** wk fName: \(user.first_name), email: \(user.email)")
                    if let fName = user.first_name,
                       let email = user.email {
                        if( fName.isEmpty || email.isEmpty) {
                            UserDefaults.standard.set(false, forKey: Keys.Persistance.isUserInfoFilled.rawValue)
                        } else {
                            UserDefaults.standard.set(true, forKey: Keys.Persistance.isUserInfoFilled.rawValue)
                        }
                    } else {
                        UserDefaults.standard.set(false, forKey: Keys.Persistance.isUserInfoFilled.rawValue)
                    }
                    
                    PersistenceManager.shared.loggedUser = userData
                    UserDefaults.standard.synchronize()
                    completion(response)
                } else if let errors = graphQLResult.errors {
                    // Handle errors
                    let response = LoginUserViewModel.MakeLoginUserRequest.Response(userObject: nil, error: true, errorMessages: errors.first?.message ?? "Something went wrong", token: "", refreshToken: "")
                    completion(response)
                }
            case .failure(let error):
                // Handle the network error
                let response = LoginUserViewModel.MakeLoginUserRequest.Response(userObject: nil, error: true, errorMessages: "unknown error happend. Please try again later ", token: "", refreshToken: "")
                completion(response)
            }
        }
    }
}
