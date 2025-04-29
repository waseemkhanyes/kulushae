//
//  FavouriteWebService.swift
//  Kulushae
//
//  Created by ios on 28/02/2024.
//


import Foundation
import Apollo

class FavouriteWebService {
    
    func fetchFavAdvList(page: Int?, userId: Int, completion: @escaping (FavouriteViewModel.GetFavRequest.Response?, Error?) -> Void) {
        
        let jsonObject: [String: Any?]  = [
            "userId":  userId,
            "page" : page
        ].removeNullValues
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.sortedKeys]) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("get fav adv params", Config.emptyData + jsonString)
                (Config.emptyData + jsonString).createSignature()
            }
        }
        
        Network.shared.apollo.fetch(query: GQLK.FavouritesQuery(userId: userId.graphQLNullable ?? nil, page: page?.graphQLNullable ?? nil), cachePolicy: .fetchIgnoringCacheData) { result in
            switch result {
            case .success(let response):
                if let responseData = response.data?.favourites?.data {
                    let favList = responseData.compactMap { item in
                        return FavouriteModel(id: item?.id,
                                              image: item?.image,
                                              size: item?.size,
                                              location: item?.location,
                                              title: item?.title,
                                              type: item?.type,
                                              userID: item?.user_id,
                                              bathrooms: item?.bathrooms,
                                              bedrooms: item?.bedrooms,
                                              price: item?.price,
                                              carYear: item?.car_year,
                                              carSteering: item?.car_steering,
                                              carSpecs: item?.car_specs,
                                              carKilometers: item?.car_kilometers)
                        
                    }
                    let response = FavouriteViewModel.GetFavRequest.Response(
                        favObject: favList,
                        total: Int(response.data?.favourites?.total ?? "0") ?? 0,
                        per_page: Int(response.data?.favourites?.per_page ?? "0") ?? 0 )
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
    
}
