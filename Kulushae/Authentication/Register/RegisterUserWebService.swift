//
//  RegisterUserWebService.swift
//  Kulushae
//
//  Created by ios on 10/10/2023.
//

import Foundation
import Apollo
import CryptoKit
import UIKit

class RegisterUserWebService {
    
    func registerUsingEmail(request: RegisterViewModel.MakeRegistrationRequest.Request,
                            completion: @escaping (RegisterViewModel.MakeRegistrationRequest.Response) -> Void = { _ in })  {
        let jsonObject: [String: Any?] = [
            "password" : request.password,
            "firstName": request.firstName,
            "lastName": request.lastName,
            "email": request.email,
            "phone": request.phone,
            "deviceId": UIDevice.current.identifierForVendor!.uuidString,
            "deviceType": "ios",
            "deviceMake": "apple",
            "deviceModel": UIDevice.current.model,
            "deviceVersion": UIDevice.current.systemVersion,
            "fcmToken": UserDefaults.standard.value(forKey: Keys.Persistance.fcmToken.rawValue) as? String,
            "type": request.type,
            "registerId": request.id
            
        ].removeNullValues
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.sortedKeys]) {
            // Step 1: Convert the JSON object to a string
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("register password params", Config.emptyData + jsonString)
                (Config.emptyData + jsonString).createSignature()
            }
        }
        
        Network.shared.apollo.perform(mutation: GQLK.RegisterMutation(
            firstName: request.firstName?.graphQLNullable ?? nil,
            lastName: request.lastName?.graphQLNullable ?? nil,
            email: request.email?.graphQLNullable ?? nil,
            phone: request.phone?.graphQLNullable ?? nil,
            type: request.type.graphQLNullable,
            registerId: request.id?.graphQLNullable ?? nil,
            deviceVersion: UIDevice.current.systemVersion.graphQLNullable,
            deviceModel: UIDevice.current.model.graphQLNullable,
            deviceMake: "apple",
            deviceType: "ios",
            deviceId: UIDevice.current.identifierForVendor!.uuidString.graphQLNullable,
            fcmToken: UserDefaults.standard.string(forKey: Keys.Persistance.fcmToken.rawValue)?.graphQLNullable ?? nil,
            password: request.password?.graphQLNullable ?? nil)
        ) { result in
            print("registerParam", request.password, request.email, request.firstName, request.lastName, request.phone)
            switch result {
            case .success(let graphQLResult):
                if let user = graphQLResult.data?.register?.user {
                    // Handle the user data
                    let userData = RegisterData(
                        email: user.email,
                        id: user.id,
                        firstName: user.first_name,
                        lastName: user.last_name,
                        image: user.image,
                        phone: user.phone
                    )
                    let response = RegisterViewModel.MakeRegistrationRequest.Response(userObject: userData, error: false, token: graphQLResult.data?.register?.token ?? "", refreshToken: graphQLResult.data?.register?.refresh_token ?? "")
                    
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
                    print("register error", errors.first?.message ?? "Something went wrong")
                    let response = RegisterViewModel.MakeRegistrationRequest.Response(userObject: nil, error: true, errorMessages: errors.first?.message ?? "Something went wrong", token:  "", refreshToken: "")
                    completion(response)
                }
            case .failure(let error):
                // Handle the network error
                
                let response = RegisterViewModel.MakeRegistrationRequest.Response(userObject: nil, error: true, errorMessages: "unknown error happened. Please try again later ", token: "", refreshToken: "")
                completion(response)
            }
        }
    }
    
    func userAvailabilyEmailOrPhone(request: RegisterViewModel.MakeForgotPasswordRequest.Request,
                                    completion: @escaping (RegisterViewModel.MakeForgotPasswordRequest.Response) -> Void = { _ in }) {
        UserDefaults.standard.set("", forKey: "signatureString")
        UserDefaults.standard.synchronize()
        let jsonObject: [String: String] = [
            "type": request.type,
            "value": request.value
        ]
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.sortedKeys]) {
            // Step 1: Convert the JSON object to a string
            print(jsonData,"jsonData")
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                (Config.emptyData + jsonString).createSignature()
                print(Config.emptyData + jsonString,"jsonData")
                Network.shared.apollo.perform(mutation: GQLK.UserVerficationMutation(value:  request.value.graphQLNullable, type: request.type.graphQLNullable)) { result in
                    UserDefaults.standard.set("", forKey: "signatureString")
                    UserDefaults.standard.synchronize()
                    switch result {
                    case .success(let graphQLResult):
                                                print(graphQLResult.data)
                        if let isExistUser = graphQLResult.data?.userVerfication?.isExist{
                            if(isExistUser) {
                                print("token is.. ", graphQLResult.data?.userVerfication?.token ?? "")
                                completion(RegisterViewModel.MakeForgotPasswordRequest.Response(success: "Success", token: graphQLResult.data?.userVerfication?.token ?? ""))
                            } else {
                                completion(RegisterViewModel.MakeForgotPasswordRequest.Response(success: "failure"))
                            }
                            
                        } else if let errors = graphQLResult.errors {
                            //                            print(graphQLResult.errors)
                            completion(RegisterViewModel.MakeForgotPasswordRequest.Response(success: "failure"))
                        }
                    case .failure(let error):
                        completion(RegisterViewModel.MakeForgotPasswordRequest.Response(success: "failure"))
                    }
                }
            }
        }
    }
}
