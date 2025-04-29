//
//  ProfileWebService.swift
//  Kulushae
//
//  Created by ios on 30/11/2023.
//

import Foundation
import Apollo

class ProfileWebService {
    
    func fetchProfileDetails(user_id: Int, completion: @escaping (ProfileViewModel.GetProfileDetailsRequest.Response?, Error?) -> Void) {
        
        let jsonObject: [String: Any?] = [
            "userInfoId" : user_id
        ].removeNullValues
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.sortedKeys]) {
            // Step 1: Convert the JSON object to a string
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("user details request", Config.emptyData + jsonString)
                (Config.emptyData + jsonString).createSignature()
            }
        }
        Network.shared.apollo.fetch(query: GQLK.UserInfoQuery(userInfoId: user_id.graphQLNullable), cachePolicy: .fetchIgnoringCacheData) { result in
            
            switch result {
            case .success(let response):
                if let userData = response.data?.userInfo {
                    let user = UserIDModel(id: userData.id,
                                           image: userData.image,
                                           firstName: userData.first_name,
                                           lastName: userData.last_name,
                                           email: userData.email,
                                           phone: userData.phone,
                                           member_since: userData.createdAt,
                                           total_listings: nil,
                                           createdAt: userData.createdAt)
                    let response = ProfileViewModel.GetProfileDetailsRequest.Response(
                        userData: user)
                    completion(response, nil) // Provide an array of CategoryListModel and nil for the error
                } else {
                    //                    print(response)
                    let error = NSError(domain: "Kulushae", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data in the response."])
                    completion(nil, error) // Provide nil for the data and an error
                }
            case .failure(let error):
                completion(nil, error) // Provide nil for the data and the actual error
            }
            completion(nil, nil)
        }
    }
    
    func deleteUserProfile( completion: @escaping (Bool?, Error?) -> Void) {
        
        Config.emptyData.createSignature()
        
        Network.shared.apollo.perform(mutation: GQLK.DeleteUserMutation()) { result in
            
            switch result {
            case .success(let response):
                if let userData = response.data?.deleteUser {
                    let isSuccess = userData.status
                    completion(isSuccess == "success", nil) // Provide an array of CategoryListModel and nil for the error
                } else {
                    print(response)
                    let error = NSError(domain: "Kulushae", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data in the response."])
                    completion(nil, error) // Provide nil for the data and an error
                }
            case .failure(let error):
                print(error)
                completion(nil, error) // Provide nil for the data and the actual error
            }
            completion(nil, nil)
        }
    }
    
    func deletePostedAds(ids: [GQLK.DeleteItem?], completion: @escaping (Bool?, Error?) -> Void) {
//        let jsonObject = convertToDictionary(ids)
        let ids = ids.compactMap({$0})
        print("** wk json: \(ids)")
        let jsonObject = convertToDictionary(ids)
        print("** wk jsonObject: \(jsonObject)")
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.sortedKeys]) {
            // Step 1: Convert the JSON object to a string
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("delete items request", Config.emptyData + jsonString)
                (Config.emptyData + jsonString).createSignature()
            }
        }
        
        Network.shared.apollo.perform(mutation: GQLK.DeleteAdsMutation(ids: ids)) { result in
            switch result {
            case .success(let response):
                if let isSuccess = response.data?.delete_item {
                    completion(isSuccess, nil)
                } else {
                    let error = NSError(domain: "Kulushae", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data in the response."])
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }


    
    func listMyAds(id: Int, page: Int, completion: @escaping (ProfileViewModel.GetUserAds.Response?, Error?) -> Void) {
        
        let jsonObject: [String: Any] = [
            "userId" : "\(id)",
            "page": "\(page)"
        ].removeNullValues
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.sortedKeys]) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("my ads  req", Config.emptyData + jsonString)
                (Config.emptyData + jsonString).createSignature()
            }
        }
        
        Network.shared.apollo.fetch(query: GQLK.UserAdsQuery(userId: id.graphQLNullable, page: page.graphQLNullable), cachePolicy: .fetchIgnoringCacheData) { result in
            switch result {
            case .success(let response):
                if let responseData = response.data?.userAds?.data {
                    let adsList = responseData.compactMap { ad in
                        return AdvModel(id: ad?.id,
                                        image: ad?.image,
                                        title: ad?.title,
                                        type: ad?.type,
                                        userID: ad?.user_id
                        )
                        
                    }
                    let response = ProfileViewModel.GetUserAds.Response(
                        advObject: adsList,
                        total: Int(response.data?.userAds?.total ?? "0") ?? 0,
                        per_page: Int(response.data?.userAds?.per_page ?? "0") ?? 0 )
                    completion(response, nil)
                } else {
                    print(response.errors)
                    let error = NSError(domain: "Kulushae", code: 0, userInfo: [NSLocalizedDescriptionKey: response.errors?.description])
                    completion(nil, error) // Provide nil for the data and an error
                }
            case .failure(let error):
                completion(nil, error)
            }
            completion(nil, nil)
        }
    }
    
    func updateUserProfile(request: ProfileViewModel.UpdateUserDetailsRequest.Request, completion: @escaping (Bool?, Error?) -> Void) {
        
        var valueDictionary: [String: String] = [:]
        
        if let fName = request.fName {
            valueDictionary["first_name"] = fName
        }
        if let lName = request.lName {
            valueDictionary["last_name"] = lName
        }
        if let email = request.email {
            valueDictionary["email"] = email
        }
        if let phone = request.phone {
            valueDictionary["phone"] = phone
        }
        if let image = request.image {
            valueDictionary["image"] = image
        }
        
        if let valueJsonData = try? JSONSerialization.data(withJSONObject: valueDictionary, options: [.sortedKeys]) {
            if let valueJsonString = String(data: valueJsonData, encoding: .utf8) {
                let jsonObject: [String: Any?] = [
                    "userId" : request.userId
                ].removeNullValues
                if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.sortedKeys]) {
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        print("user update request", Config.emptyData + jsonString)
                        (Config.emptyData + jsonString).createSignature()
                    }
                }
                Network.shared.apollo.perform(mutation: GQLK.UpdateUserMutation(userId: GraphQLNullable<Int>(integerLiteral: request.userId), values: GraphQLNullable<String>(stringLiteral: valueJsonString))) { result in
                    
                    switch result {
                    case .success(let response):
                        //                        print("update image respon", response)
                        if let id = response.data?.updateUser?.id {
                            completion(true, nil)
                        }
                        
                    case .failure(let error):
                        completion(false, error) // Provide nil for the data and the actual error
                    }
                }
            }
        }
        
        
    }
    
    func convertToDictionary(_ items: [GQLK.DeleteItem]) -> [String: Any] {
        let itemDicts = items.map { ["type": $0.type.unwrapped ?? "", "id": $0.id.unwrapped ?? 0] }
        return ["ids": itemDicts]
    }

}

