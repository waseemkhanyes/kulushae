//
//  CardetailsWebservices.swift
//  Kulushae
//
//  Created by ios on 01/04/2024.
//

import Foundation
import Apollo

class CarDetailsWebService {
    
    func fetchCarDetails(carId: Int, completion: @escaping (CarDetailsViewModel.GetCarDetailsRequest.Response?, Error?) -> Void) {
        
        let jsonObject: [String: Any?] = [
            "motorId" : carId
        ].removeNullValues
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.sortedKeys]) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Car details request", Config.emptyData + jsonString)
                (Config.emptyData + jsonString).createSignature()
            }
        }
        
        Network.shared.apollo.fetch(query: GQLK.MotorQuery(motorId: carId.graphQLNullable), cachePolicy: .fetchIgnoringCacheData) { result in
            switch result {
            case .success(let response):
                if let motor = response.data?.motor {
                    let motorData = PostedCars(id: motor.id,
                                               emirates: motor.emirates,
                                               make: motor.make,
                                               model: motor.model,
                                               trim: motor.trim,
                                               specs: motor.specs,
                                               year: motor.year,
                                               kilometers: motor.kilometers,
                                               insuredInUae: motor.insured_in_uae,
                                               price: motor.price,
                                               contactInfo: motor.contact_info,
                                               title: motor.title,
                                               desc: motor.desc,
                                               tourURL: motor.tour_url,
                                               fuelType: motor.fuel_type,
                                               exteriorColor: motor.exterior_color,
                                               interiorColor: motor.interior_color,
                                               warranty: motor.warranty,
                                               doors: motor.doors,
                                               noOfCylinders: motor.no_of_cylinders,
                                               transmissionType: motor.transmission_type,
                                               bodyType: motor.body_type,
                                               seatingCapacity: motor.seating_capacity,
                                               horsepwer: motor.horsepwer,
                                               engineCapacity: motor.engine_capacity,
                                               steeringSide: motor.steering_side,
                                               seller: motor.seller,
                                               extras: motor.extras?.compactMap({ extra in
                                                    return Extra(id: extra?.id, title: extra?.title)
                                                }),
                                               images:  motor.images?.compactMap{ image in
                                                    return ImageModel(id: image?.id, image: image?.image)
                                                },
                                               isFavorite: motor.is_favorite,
                                               type: motor.type,
                                               userID: UserIDModel(
                                                id: motor.user_id?.id,
                                                image: motor.user_id?.image,
                                                firstName: motor.user_id?.first_name ?? "",
                                                lastName: motor.user_id?.last_name ?? "",
                                                email: motor.user_id?.email ?? "",
                                                phone: motor.user_id?.phone ?? "",
                                                member_since: motor.user_id?.member_since,
                                                total_listings: motor.user_id?.total_listings,
                                                createdAt: nil
                                               ),
                                               categoryID: motor.category_id,
                                               makeId: motor.make_id,
                                               modelId: motor.model_id,
                                               isNew: motor.is_new
                                               
                    )
                    let response = CarDetailsViewModel.GetCarDetailsRequest.Response(motorObject: motorData)
                    completion(response, nil)
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
    
    func insertToFavourite(CarId: Int, isLike: Bool, type: String , completion: @escaping (Bool?, Error?) -> Void) {
        
        let jsonObject: [String: Any?] = [
            "like": isLike,
            "itemId": CarId,
            "type": type
        ].removeNullValues
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.sortedKeys]) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Insert Fav Request", Config.emptyData + jsonString)
                (Config.emptyData + jsonString).createSignature()
            }
        }
        
        Network.shared.apollo.perform(mutation: GQLK.Add_favoriteMutation(like: isLike, itemId: CarId.graphQLNullable, type: type.graphQLNullable)) { result in
            switch result {
            case .success(let response):
                if let success = response.data?.add_favorite {
                    print("add fav response", success)
                    completion(success, nil)
                }
                
            case .failure(let error):
                completion(false, error)
            }
        }
    }
    
}
