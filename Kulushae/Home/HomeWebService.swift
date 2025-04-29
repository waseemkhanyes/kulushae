//
//  HomeWebService.swift
//  Kulushae
//
//  Created by ios on 17/10/2023.
//

import Foundation
import Apollo
@_exported import SwiftyJSON

extension [String: Any?] {
    var removeNullValues: [String: Any?] {
        self.filter({$0.value != nil})
    }
}

class HomeWebService {
    
    func fetchCategoryList(afl: Int?, catId: Int?,showOnScreen: Int?, completion: @escaping ([CategoryListModel]?, Error?) -> Void) {
        
        var jsonObject: [String: Any?] = [
            "afl" : afl,
            "categoryId": catId,
            "showOnScreen" : showOnScreen
        ].removeNullValues
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.sortedKeys]) {
            // Step 1: Convert the JSON object to a string
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("cat params", Config.emptyData + jsonString)
                (Config.emptyData + jsonString).createSignature()
            }
        }
        
        
        Network.shared.apollo.fetch(query: GQLK.CategoriesQuery(
                showOnScreen: showOnScreen?.graphQLNullable ?? nil,
                afl: afl?.graphQLNullable ?? nil,
                categoryId: catId?.graphQLNullable ?? nil
            ),
            cachePolicy: .fetchIgnoringCacheData
        ) { result in
            switch result {
            case .success(let response):
                if let categories = response.data?.categories {
                    //                    print(categories)
                    // Map GraphQL data to your model
                    let categoryList = categories.compactMap { category in
                        return CategoryListModel(
                            id: category?.id ?? "",
                            image: category?.image,
                            parentID: "\(category?.parent_id ?? 0)",
                            title: category?.title ?? "",
                            active_for_listing: category?.active_for_listing ?? false,
                            has_child: category?.has_child ?? false,
                            has_form: category?.has_form ?? false,
                            service_type: category?.service_type ?? "",
                            bgColor: category?.bgColor ?? ""
                        )
                    }
                    completion(categoryList, nil) // Provide an array of CategoryListModel and nil for the error
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
    
    func fetchSubCategoryList(afl: Int?, catId: Int?,showOnScreen: Int?, completion: @escaping ([CategoryListModel]?, Error?) -> Void) {
        
        let jsonObject: [String: Any?] = [
            "afl" : afl,
            "categoryId": catId,
            "showOnScreen" : showOnScreen
        ].removeNullValues
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.sortedKeys]) {
            // Step 1: Convert the JSON object to a string
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Sub cat params", Config.emptyData + jsonString)
                (Config.emptyData + jsonString).createSignature()
            }
        }
        
        // Create PropertiesQuery with variables
        let categoryQuery = GQLK.CategoriesQuery(
            showOnScreen: showOnScreen?.graphQLNullable ?? nil,
            afl: afl?.graphQLNullable ?? nil,
            categoryId: catId?.graphQLNullable ?? nil
        )
        
        
        Network.shared.apollo.fetch(query: categoryQuery, cachePolicy: .fetchIgnoringCacheData) { result in
            switch result {
            case .success(let response):
                if let categories = response.data?.categories {
                    //                    print(categories)
                    // Map GraphQL data to your model
                    let categoryList = categories.compactMap { category in
                        return CategoryListModel(
                            id: category?.id ?? "",
                            image: category?.image,
                            parentID: "\(category?.parent_id ?? 0)",
                            title: category?.title ?? "",
                            active_for_listing: category?.active_for_listing ?? false,
                            has_child: category?.has_child ?? false,
                            has_form: category?.has_form ?? false,
                            service_type: category?.service_type ?? "",
                            bgColor: category?.bgColor ?? ""
                        )
                    }
                    completion(categoryList, nil) // Provide an array of CategoryListModel and nil for the error
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
    
    
    func fetchAddedAdvList(page: Int?,userId: Int?, filterArray: [String: Any]?, catId: Int? , completion: @escaping (HomeViewModel.GetAdvRequest.Response?, Error?) -> Void) {
        
        var jsonObject : [String: Any?] = [:]
        if(filterArray == nil) {
            jsonObject  = [
                "page" : page,
                "userId": userId,
                "filters": filterArray,
                "categoryId": catId
            ]
        } else {
            jsonObject = [
                "page" : page,
                "userId": userId,
                "categoryId": catId
            ]
        }
        let jsonObject1: [String: Any?]  = [
            "page" : page,
            "userId": userId,
            "filters": filterArray,
            "categoryId": catId
        ]
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject1, options: [.sortedKeys]) {
            // Step 1: Convert the JSON object to a string
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("get add with filter params",  jsonString)
                
            }
        }
        
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject.removeNullValues, options: [.sortedKeys]) {
            // Step 1: Convert the JSON object to a string
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("get add with filter params", Config.emptyData + jsonString)
                (Config.emptyData + jsonString).createSignature()
            }
        }
        
        
        
        
        
        let filtersJSONString: String?
        if let filterArray = filterArray {
            let jsonData = try? JSONSerialization.data(withJSONObject: filterArray, options: [])
            filtersJSONString = String(data: jsonData!, encoding: .utf8)
        } else {
            filtersJSONString = nil
        }
        
        // Create PropertiesQuery with variables
        let propertiesQuery = GQLK.PropertiesQuery(
            page: page?.graphQLNullable ?? nil,
            userId: userId?.graphQLNullable ?? nil,
            categoryId: catId?.graphQLNullable ?? nil, filters: filtersJSONString?.graphQLNullable ?? nil
        )
        
        Network.shared.apollo.fetch(query: propertiesQuery, cachePolicy: .fetchIgnoringCacheData) { result in
            switch result {
            case .success(let response):
                if let responseData = response.data?.properties?.data {
                    //                                        print(responseData)
                    // Map GraphQL data to your model
                    let propertyList = responseData.compactMap { property in
                        return PropertyData(id: property?.id,
                                            title: property?.title,
                                            contactNumber: nil,
                                            description_val: nil,
                                            socialmedia: nil,
                                            size: property?.size,
                                            bedrooms: property?.bedrooms,
                                            bathrooms: property?.bathrooms,
                                            amenities: nil,
                                            userID: nil,
                                            neighbourhood: property?.neighbourhood,
                                            location: property?.location,
                                            categoryID: property?.category_id,
                                            images: property?.images?.compactMap{ image in
                            return ImageModel(id: image?.id, image: image?.image)
                        },
                                            price: property?.price,
                                            isFeatured: property?.is_featured,
                                            isFavorite: property?.is_favorite,
                                            type: property?.type,
                                            youtube_url: nil,
                                            three_sixty_url: nil,
                                            country: property?.country,
                                            emirates: property?.emirates,
                                            deposit: property?.deposit,
                                            referenceNumber: property?.reference_number,
                                            developer: property?.developer,
                                            readyBy: property?.ready_by,
                                            anualCommunityFee: trim(property?.annual_community_fee),
                                            furnished: property?.furnished,
                                            totalClosingFee: property?.total_closing_fee,
                                            buyerTransferFee: property?.buyer_transfer_fee,
                                            sellerTransferFee: property?.seller_transfer_fee,
                                            maintenanceFee: property?.maintenance_fee,
                                            occupancyStatus: property?.occupancy_status,
                                            postedBy: property?.posted_by
                                            
                        )
                        
                    }
                    let response = HomeViewModel.GetAdvRequest.Response(
                        advObject: propertyList,
                        total: Int(response.data?.properties?.total ?? "0") ?? 0,
                        per_page: Int(response.data?.properties?.per_page ?? "0") ?? 0 )
                    completion(response, nil) // Provide an array of CategoryListModel and nil for the error
                } else {
                    print(response.errors)
                    let error = NSError(domain: "Kulushae", code: 0, userInfo: [NSLocalizedDescriptionKey: response.errors?.description])
                    completion(nil, error) // Provide nil for the data and an error
                }
            case .failure(let error):
                print("filter error",error)
                completion(nil, error) // Provide nil for the data and the actual error
            }
        }
    }
    
    func fetchAddedCarList(page: Int?,userId: Int?, filterArray: [String: Any]?, catId: Int? , completion: @escaping (HomeViewModel.GetCarRequest.Response?, Error?) -> Void) {
        
        var jsonObject : [String: Any?] = [:]
        if(filterArray == nil) {
            jsonObject  = [
                "page" : page,
                "userId": userId,
                "filters": filterArray,
                "categoryId": catId
            ]
        } else {
            jsonObject = [
                "page" : page,
                "userId": userId,
                "categoryId": catId
            ]
        }
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject.removeNullValues, options: [.sortedKeys]) {
            // Step 1: Convert the JSON object to a string
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("get car with filter params", Config.emptyData + jsonString)
                (Config.emptyData + jsonString).createSignature()
            }
        }
        
        let filtersJSONString: String?
        if let filterArray = filterArray {
            let jsonData = try? JSONSerialization.data(withJSONObject: filterArray, options: [])
            filtersJSONString = String(data: jsonData!, encoding: .utf8)
        } else {
            filtersJSONString = nil
        }
        
        let motorQuery = GQLK.MotorsQuery(
            page: page?.graphQLNullable ?? nil,
            userId: userId?.graphQLNullable ?? nil,
            categoryId: catId?.graphQLNullable ?? nil,
            filters: filtersJSONString?.graphQLNullable ?? nil
        )
        
        Network.shared.apollo.fetch(query: motorQuery, cachePolicy: .fetchIgnoringCacheData) { result in
            switch result {
            case .success(let response):
                if let responseData = response.data?.motors?.data {
                    
                    
                    let motorList = responseData.compactMap { motor in
                        return PostedCars(id: motor?.id,
                                          emirates: motor?.emirates,
                                          make: motor?.make,
                                          model: motor?.model,
                                          trim: motor?.trim,
                                          specs: motor?.specs,
                                          year: motor?.year,
                                          kilometers: motor?.kilometers,
                                          insuredInUae: motor?.insured_in_uae,
                                          price: motor?.price,
                                          contactInfo: motor?.contact_info,
                                          title: motor?.title,
                                          desc: motor?.desc,
                                          tourURL: motor?.tour_url,
                                          fuelType: motor?.fuel_type,
                                          exteriorColor: motor?.exterior_color,
                                          interiorColor: motor?.interior_color,
                                          warranty: motor?.warranty,
                                          doors: motor?.doors,
                                          noOfCylinders: motor?.no_of_cylinders,
                                          transmissionType: motor?.transmission_type,
                                          bodyType: motor?.body_type,
                                          seatingCapacity: motor?.seating_capacity,
                                          horsepwer: motor?.horsepwer,
                                          engineCapacity: motor?.engine_capacity,
                                          steeringSide: motor?.steering_side,
                                          seller: motor?.seller,
                                          extras: [],
                                          images:  motor?.images?.compactMap{ image in
                                            return ImageModel(id: image?.id, image: image?.image)
                                          },
                                          isFavorite: motor?.is_favorite ?? false, type: motor?.type ?? "", categoryID: motor?.category_id ?? 0,
                                          makeId: motor?.make_id,
                                          modelId: motor?.model_id,
                                          isNew: motor?.is_new
                        )
                        
                    }
                    let response = HomeViewModel.GetCarRequest.Response(
                        carObject: motorList,
                        total: Int(response.data?.motors?.total ?? "0") ?? 0,
                        per_page: Int(response.data?.motors?.per_page ?? "0") ?? 0 )
                    completion(response, nil)
                } else {
                    print(response.errors)
                    let error = NSError(domain: "Kulushae", code: 0, userInfo: [NSLocalizedDescriptionKey: response.errors?.description])
                    completion(nil, error) // Provide nil for the data and an error
                }
            case .failure(let error):
                print("filter error",error)
                completion(nil, error) // Provide nil for the data and the actual error
            }
        }
    }
    
    func fetchCountriesList(completion: @escaping ([KulushaeCountry], Error?) -> Void) {
//        print(Config.baseURL + Config.countryList)
        RestAPINetworkManager.shared.getRequest(url: Config.baseURL + Config.countryList) { result in
            switch result {
            case .success(let data):
                // Handle successful response
                do {
                    let decoder = JSONDecoder()
                    let countries = try decoder.decode([KulushaeCountry].self, from: data)
                    let activeCountries = countries.filter { $0.activeForListing == 1 }
                    completion(activeCountries, nil) // Return parsed countries
                } catch {
                    completion([], error) // Return empty array and error
                }
            case .failure(let error):
                // Handle error
                completion([], error) // Return empty array and error
            }
        }
    }
    
    func fetchMotorQuickLinks(completion: @escaping (JSON, Error?) -> Void) {
//        print(Config.baseURL + Config.countryList)
        RestAPINetworkManager.shared.callEndPoint(url: Config.baseURL + Config.quickLinks, parameters: ["service_type": "motors"], headers: ["X-App-Language": "en"]) { response in
            switch response.result {
            case .success(let value):
                // Handle successful response
                do {
                    let jsonData = JSON(value)
                    completion(jsonData, nil) // Return parsed countries
                } catch {
                    completion([], error) // Return empty array and error
                }
            case .failure(let error):
                // Handle error
                completion([], error) // Return empty array and error
            }
        }
    }
    
    func fetchMotorFilters(completion: @escaping (JSON, Error?) -> Void) {
//        print(Config.baseURL + Config.countryList)
        RestAPINetworkManager.shared.callEndPoint(
            url: Config.baseURL + Config.filters,
            parameters: ["service_type": "motors", "country_id": PersistenceManager.shared.countryDataForSearch?.country.id ?? 0],
            headers: ["X-App-Language": UserDefaults.standard.string(forKey: "AppLanguage") ?? "en"]
        ) { response in
            switch response.result {
            case .success(let value):
                // Handle successful response
                do {
                    let jsonData = JSON(value)
                    completion(jsonData, nil) // Return parsed countries
                } catch {
                    completion([], error) // Return empty array and error
                }
            case .failure(let error):
                // Handle error
                completion([], error) // Return empty array and error
            }
        }
    }
    
    func fetchBannersList(serviceID:String,completion: @escaping ([BannerModel], Error?) -> Void) {
//        print(Config.baseURL + Config.countryList)
        RestAPINetworkManager.shared.postRequest(url: Config.baseURL + Config.bannersList, parameters: ["service_type":serviceID]) { result in
            switch result {
            case .success(let data):
                // Handle successful response
                do {
                    let decoder = JSONDecoder()
                    let countries = try decoder.decode([BannerModel].self, from: data)
                    let activeCountries = countries.filter { $0.active_status == 1 }
                    completion(activeCountries, nil) // Return parsed countries
                } catch {
                    completion([], error) // Return empty array and error
                }
            case .failure(let error):
                // Handle error
                completion([], error) // Return empty array and error
            }
        }

    }
    
    func fetchCarMake(completion: @escaping ([MotorMake], Error?) -> Void) {
        
        (Config.emptyData ).createSignature()
        
        Network.shared.apollo.fetch(query: GQLK.Motor_makesQuery(page: nil, value: nil), cachePolicy: .fetchIgnoringCacheData) { result in
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
}

