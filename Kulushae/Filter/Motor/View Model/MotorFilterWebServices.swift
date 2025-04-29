//
//  MotorFilterWebServices.swift
//  Kulushae
//
//  Created by ios on 12/05/2024.
//

import Foundation
class MotorFilterWebServices {
    
    func fetchCarMake(page: Int? = 1, completion: @escaping ([MotorMake], Error?) -> Void) {
        
        (Config.emptyData ).createSignature()
        
        Network.shared.apollo.fetch(query: GQLK.Motor_makesQuery(page: page?.graphQLNullable ?? nil, value: "".graphQLNullable), cachePolicy: .fetchIgnoringCacheData) { result in
            switch result {
            case .success(let response):
                if let makeList = response.data?.motor_makes?.data {
                    completion(
                        makeList.compactMap{ make in
                            return MotorMake(id: make?.id ?? "0",
                                             title: make?.title ?? "", image: make?.image ?? "")
                        },
                        nil)
                } else {
                    //                    print(response)
                    let error = NSError(domain: "Kulushae", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data in the response."])
                    completion([], error) // Provide nil for the data and an error
                }
            case .failure(let error):
                completion([], error) // Provide nil for the data and the actual error
            }
        }
    }
    
    func fetchCarModel(id: String, completion: @escaping ([MotorModel], Error?) -> Void) {
        (Config.emptyData ).createSignature()
        
        Network.shared.apollo.fetch(query: GQLK.Motor_modelsQuery(makeId: Int(id)?.graphQLNullable ?? nil), cachePolicy: .fetchIgnoringCacheData) { result in
            switch result {
            case .success(let response):
                print(response)
                if let modelList = response.data?.motor_models {
                    completion(
                        modelList.compactMap{
                            model in
                            return MotorModel(
                                id: model?.id ?? "0",
                                motorMakeID: model?.motor_make_id,
                                title: model?.title ?? "",
                                image: model?.image
                            )
                        },
                        nil)
                } else {
                    //                    print(response)
                    let error = NSError(domain: "Kulushae", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data in the response."])
                    completion([], error) // Provide nil for the data and an error
                }
            case .failure(let error):
                completion([], error) // Provide nil for the data and the actual error
            }
        }
    }
    
    func fetchStateList(completion: @escaping (StatesModel, Error?) -> Void) {
        
        let country_id = "\(UserDefaultManager.get(.choseCityId) ?? -1)"
        print(Config.baseURL + Config.statesList + country_id)
        
        RestAPINetworkManager.shared.getRequest(url: Config.baseURL + Config.statesList + country_id) { result in
            switch result {
            case .success(let data):
                // Handle successful response
                do {
                    let decoder = JSONDecoder()
                    let states = try decoder.decode(StatesModel.self, from: data)
                    completion(states, nil)
                } catch {
                    completion([], error)
                }
            case .failure(let error):
                // Handle error
                completion([], error)
            }
        }
    }
}
