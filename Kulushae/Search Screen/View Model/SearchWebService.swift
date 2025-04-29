//
//  SearchWebService.swift
//  Kulushae
//
//  Created by ios on 26/02/2024.
//

import Foundation
import Apollo

class SearchWebService {
    
    func fetchSearchItems(searchKey: String, serviceType: String, completion: @escaping ([SearchModel]?, Error?) -> Void) {
        
        let jsonObject: [String: Any?] = [
            "value" : searchKey
        ].removeNullValues
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.sortedKeys]) {
            // Step 1: Convert the JSON object to a string
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("search request", Config.emptyData + jsonString)
                (Config.emptyData + jsonString).createSignature()
            }
        }
        Network.shared.apollo.fetch(query: GQLK.SearchQuery(value: searchKey, serviceType: serviceType), cachePolicy: .fetchIgnoringCacheData) { result in
            switch result {
            case .success(let response):
                if let searchData = response.data?.search {
                    let searchList = searchData.compactMap { item in
                        return SearchModel(ads: item?.ads,
                                           category: item?.category,
                                           categoryID: item?.category_id,
                                           propertyTitle: item?.title,
                                           type: item?.type)
                    }
                    completion(searchList, nil)
                } else {
                    completion([], response.errors?.first)
                }
            case .failure(let error):
                completion(nil, error) // Provide nil for the data and the actual error
            }
        }
    }
    
}
