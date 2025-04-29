//
//  MotorMakesApiService.swift
//  Kulushae
//
//  Created by Waseem  on 12/11/2024.
//

import Foundation
import Apollo

class MotorMakesApiService {
    
    func fetchCarMake(request: MotorMakesListModel.GetCarMakeRequest.Request, completion: @escaping (MotorMakesListModel.GetCarMakeRequest.Response?, Error?) -> Void) {
        
        (Config.emptyData ).createSignature()
        
        let motorMakes = GQLK.Motor_makesQuery(
            page: request.page.graphQLNullable, value: (request.value ?? "").graphQLNullable
        )
        
        Network.shared.apollo.fetch(query: motorMakes, cachePolicy: .fetchIgnoringCacheData) { result in
            switch result {
            case .success(let response):
                if let motorMakes = response.data?.motor_makes {
                    var arrayMake: [MotorMake] = []
                    if let makeList = motorMakes.data {
                        arrayMake = makeList.compactMap{ make in
                            return MotorMake(id: make?.id ?? "0",
                                             title: make?.title ?? "", image: make?.image ?? "")
                        }
                    }
                    completion(
                        MotorMakesListModel.GetCarMakeRequest.Response(
                            arrayMotorMake: arrayMake,
                            perPage: Int(motorMakes.per_page ?? "0") ?? 0,
                            currentPage: Int(motorMakes.current_page ?? "0") ?? 0,
                            total: Int(motorMakes.total ?? "0") ?? 0
                        ),
                        nil
                    )
                } else {
                    //                    print(response)
                    let error = NSError(domain: "Kulushae", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data in the response."])
                    completion(nil, error) // Provide nil for the data and an error
                }
            case .failure(let error):
                completion(nil, error) // Provide nil for the data and the actual error
            }
        }
    }
    
    func fetchCarModel(request: MotorMakesListModel.GetCarModelRequest.Request, completion: @escaping (MotorMakesListModel.GetCarModelRequest.Response?, Error?) -> Void) {
        
        (Config.emptyData ).createSignature()
        
        let motorModel = GQLK.Motor_modelsQuery(
            makeId: request.makeId.graphQLNullable
        )
        
        Network.shared.apollo.fetch(query: motorModel, cachePolicy: .fetchIgnoringCacheData) { result in
            switch result {
            case .success(let response):
                if let models = response.data?.motor_models {
                    let motorModels = models.compactMap({
                        item in
                        return MotorModel(
                            id: item?.id,
                            motorMakeID: item?.motor_make_id,
                            title: item?.title,
                            image: item?.image
                        )
                    })
                    completion(
                        MotorMakesListModel.GetCarModelRequest.Response(
                            motorModels: motorModels
                        ),
                        nil
                    )
                } else {
                    //                    print(response)
                    let error = NSError(domain: "Kulushae", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data in the response."])
                    completion(nil, error) // Provide nil for the data and an error
                }
            case .failure(let error):
                completion(nil, error) // Provide nil for the data and the actual error
            }
        }
    }
}
