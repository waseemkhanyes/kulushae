//
//  AdDetailsWebService.swift
//  Kulushae
//
//  Created by ios on 30/10/2023.
//

//import Foundation
//import Apollo
//
//class AdDetailsWebService {
//    
//    func fetchFormDataList( catId: Int,steps: Int?, completion: @escaping ([[FetchFormDataModel]]?, Error?) -> Void) {
//        //        print("stepnum", steps)
//        let jsonObject: [String: Any?] = [
//            "categoryId": catId,
//            "steps": steps
//        ].removeNullValues
//        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.sortedKeys]) {
//            if let jsonString = String(data: jsonData, encoding: .utf8) {
//                print("form params", Config.emptyData + jsonString)
//                (Config.emptyData + jsonString).createSignature()
//            }
//        }
//        Network.shared.apollo.fetch(query: GQLK.FetchFormQuery(categoryId: catId, steps: steps?.graphQLNullable ?? nil), cachePolicy: .fetchIgnoringCacheData) { result in
//            switch result {
//            case .success(let response):
//                //                print(response)
//                if let formData = response.data?.fetchForm {
//                    //                    print(formData)
//                    var array: [[FetchFormDataModel]] = []
//                    
//                    // Use compactMap to convert the data
//                    let convertedData = formData.compactMap { data in
//                        return data?.map { fetchForm in
//                            // Perform the conversion from FetchForm to FetchFormDataModel here
//                            return FetchFormDataModel(fieldExtras: FieldExtras(jsonString: fetchForm?.field_extras ?? "") ,
//                                                      fieldName: fetchForm?.field_name ?? "" ,
//                                                      fieldOrder: fetchForm?.field_order ?? -1,
//                                                      fieldRequestType: fetchForm?.field_request_type ?? "",
//                                                      fieldSize: fetchForm?.field_size ?? -1,
//                                                      fieldType: fetchForm?.field_type ?? "",
//                                                      fieldValidation: fetchForm?.field_validation ?? "",
//                                                      id: fetchForm?.id ?? "",
//                                                      steps: fetchForm?.steps ?? -1,
//                                                      categoryID: fetchForm?.category_id ?? -1)
//                        }
//                    }
//                    
//                    // Append the converted data to the array
//                    array.append(contentsOf: convertedData)
//                    array = array.map { $0.sorted { $0.fieldOrder < $1.fieldOrder } }
//                    
//                    completion(array, nil) // Provide an array of CategoryListModel and nil for the error
//                } else {
//                    //                    print(response)
//                    let error = NSError(domain: "Kulushae", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data in the response."])
//                    completion(nil, error) // Provide nil for the data and an error
//                }
//            case .failure(let error):
//                completion(nil, error) // Provide nil for the data and the actual error
//            }
//        }
//    }
//    
//    func fetchAmenityDataList( completion: @escaping ([AmenityList]?, Error?) -> Void) {
//        
//        Config.emptyData.createSignature()
//        Network.shared.apollo.fetch(query: GQLK.AmenitiesQuery(), cachePolicy: .fetchIgnoringCacheData) { result in
//            switch result {
//            case .success(let response):
//                if let amenities = response.data?.amenities {
//                    //                    print(amenities)
//                    let amenityList = amenities.compactMap { amenity in
//                        return AmenityList(
//                            id: amenity?.id ?? "",
//                            title: amenity?.title ?? ""
//                        )
//                    }
//                    completion(amenityList, nil) // Provide an array of CategoryListModel and nil for the error
//                } else {
//                    //                    print(response)
//                    let error = NSError(domain: "Kulushae", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data in the response."])
//                    completion(nil, error) // Provide nil for the data and an error
//                }
//            case .failure(let error):
//                completion(nil, error) // Provide nil for the data and the actual error
//            }
//        }
//    }
//    
//    func fetchMotorDataList( completion: @escaping ([AmenityList]?, Error?) -> Void) {
//        
//        Config.emptyData.createSignature()
//        Network.shared.apollo.fetch(query: GQLK.Motor_extrasQuery(), cachePolicy: .fetchIgnoringCacheData) { result in
//            switch result {
//            case .success(let response):
//                if let amenities = response.data?.motor_extras {
//                    let amenityList = amenities.compactMap { amenity in
//                        return AmenityList(
//                            id: amenity?.id ?? "",
//                            title: amenity?.title ?? ""
//                        )
//                    }
//                    completion(amenityList, nil)
//                } else {
//                    let error = NSError(domain: "Kulushae", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data in the response."])
//                    completion(nil, error)
//                }
//            case .failure(let error):
//                completion(nil, error)
//            }
//        }
//    }
//    
//    func submitAdvertisement(request: [String: Any?],
//                             completion: @escaping (AdDetailsViewModel.MakeAdSubmit.Response) -> Void = { _ in })  {
//        if let jsonData = try? JSONSerialization.data(withJSONObject: request.removeNullValues, options: [.sortedKeys]) {
//            // Step 1: Convert the JSON object to a string
//            
//            if let jsonString = String(data: jsonData, encoding: .utf8) {
//                print("add submit params", Config.emptyData + jsonString)
//                (Config.emptyData).createSignature()
//                
//                Network.shared.apollo.perform(mutation: GQLK.Store_propertyMutation(args: jsonString.graphQLNullable)) { result in
//                    
//                    switch result {
//                    case .success(let graphQLResult):
//                        
//                        if let response = graphQLResult.data?.store_property {
//                            
//                            let response =
//                            
//                            AdDetailsViewModel.MakeAdSubmit.Response(
//                                response: SubmitResponseModel(
//                                    data: SubmitAddData(
//                                        storeProperty: StoreProperty(
//                                            status: response.status,
//                                            message: response.message,
//                                            payment: PaymentModel(
//                                                amount: response.payment?.amount ?? "",
//                                                cart_description:  response.payment?.cart_description ?? "",
//                                                cart_id: response.payment?.cart_id ?? "",
//                                                country_code: response.payment?.country_code ?? "",
//                                                currency_code: response.payment?.currency_code ?? ""
//                                            )
//                                        )
//                                    )
//                                )
//                            )
//                            completion(response)
//                            
//                            
//                        } else if let errors = graphQLResult.errors {
//                            for graphQLError in errors {
//                                let submitError = SubmitErrorModel(graphQLError: graphQLError)
//                                let response = AdDetailsViewModel.MakeAdSubmit.Response(response: SubmitResponseModel(data: nil, errors: [submitError]))
//                                completion(response)
//                            }
//                        }
//                        
//                    case .failure(let error):
//                        // Handle the network error
//                        print("failure errr", error)
//                        let response = AdDetailsViewModel.MakeAdSubmit.Response()
//                        completion(response)
//                    }
//                }
//            }
//        }
//    }
//    
//    func submitCars(request: [String: Any?],
//                             completion: @escaping (AdDetailsViewModel.MakeAdSubmit.Response) -> Void = { _ in })  {
//        if let jsonData = try? JSONSerialization.data(withJSONObject: request.removeNullValues, options: [.sortedKeys]) {
//            if let jsonString = String(data: jsonData, encoding: .utf8) {
//                print("add submit params", Config.emptyData + jsonString)
//                (Config.emptyData).createSignature()
//                
//                Network.shared.apollo.perform(mutation: GQLK.Store_motorsMutation(args: jsonString.graphQLNullable)) { result in
//                    
//                    switch result {
//                    case .success(let graphQLResult):
//                        
//                        if let response = graphQLResult.data?.store_motors {
//                            
//                            let response =
//                            
//                            AdDetailsViewModel.MakeAdSubmit.Response(response: SubmitResponseModel(data: SubmitAddData(storeProperty: StoreProperty(status: response.status, message: response.message, payment: PaymentModel(amount: response.payment?.amount ?? "", cart_description:  response.payment?.cart_description ?? "", cart_id: response.payment?.cart_id ?? "", country_code: response.payment?.country_code ?? "", currency_code: response.payment?.currency_code ?? ""))) , errors: nil))
//                            completion(response)
//                            
//                            
//                        } else if let errors = graphQLResult.errors {
//                            for graphQLError in errors {
//                                let submitError = SubmitErrorModel(graphQLError: graphQLError)
//                                let response = AdDetailsViewModel.MakeAdSubmit.Response(response: SubmitResponseModel(data: nil, errors: [submitError]))
//                                completion(response)
//                            }
//                        }
//                        
//                    case .failure(let error):
//                        // Handle the network error
//                        print("failure errr", error)
//                        let response = AdDetailsViewModel.MakeAdSubmit.Response()
//                        completion(response)
//                    }
//                }
//            }
//        }
//    }
//}
//
//
