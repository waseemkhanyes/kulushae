//
//  ProductDetailsWebService.swift
//  Kulushae
//
//  Created by ios on 29/11/2023.
//

import Foundation
import Apollo

class ProductDetailsWebService {
    
    func fetchAdDetails(productId: Int, completion: @escaping (ProductDetailsViewModel.GetProductDetailsRequest.Response?, Error?) -> Void) {
        
        let jsonObject: [String: Any?] = [
            "propertyId" : productId
        ].removeNullValues
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.sortedKeys]) {
            // Step 1: Convert the JSON object to a string
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("product details request", Config.emptyData + jsonString)
                (Config.emptyData + jsonString).createSignature()
            }
        }
        Network.shared.apollo.fetch(query: GQLK.PropertyQuery(propertyId:  productId.graphQLNullable), cachePolicy: .fetchIgnoringCacheData) { result in
            switch result {
            case .success(let response):
                if let property = response.data?.property {
                    let propertyList =  PropertyData(id: property.id,
                                                     title: property.title,
                                                     contactNumber: property.contact_number,
                                                     description_val: property.description,
                                                     socialmedia: property.socialmedia?.compactMap{ social in
                        SocialmediaModel(id: social?.id, type: social?.type, value: social?.value)
                    },
                                                     size: property.size,
                                                     bedrooms: property.bedrooms,
                                                     bathrooms: property.bathrooms,
                                                     amenities: property.amenities?.compactMap { amenity in
                        return AmenityModel(id: amenity?.id, title: amenity?.title)},
                                                     userID: UserIDModel(id: property.user_id?.id,
                                                                         image: property.user_id?.image,
                                                                         firstName: property.user_id?.first_name ?? "",
                                                                         lastName: property.user_id?.last_name ?? "",
                                                                         email: property.user_id?.email ?? "",
                                                                         phone: property.user_id?.phone ?? "",
                                                                         member_since: property.user_id?.member_since,
                                                                         total_listings: property.user_id?.total_listings, createdAt: nil),
                                                     neighbourhood: property.neighbourhood,
                                                     location: property.location,
                                                     categoryID: property.category_id,
                                                     images: property.images?.compactMap{ image in
                        return ImageModel(id: image?.id, image: image?.image)
                    },
                                                     price: property.price,
                                                     isFeatured: property.is_featured,
                                                     isFavorite: property.is_favorite,
                                                     type: property.type,
                                                     youtube_url: nil,
                                                     three_sixty_url: nil,
                                                     country: property.country,
                                                     emirates: property.emirates,
                                                     deposit: property.deposit,
                                                     referenceNumber: property.reference_number,
                                                     developer: property.developer,
                                                     readyBy: property.ready_by,
                                                     anualCommunityFee: trim(property.annual_community_fee),
                                                     furnished: property.furnished,
                                                     totalClosingFee: property.total_closing_fee,
                                                     buyerTransferFee: property.buyer_transfer_fee,
                                                     sellerTransferFee: property.seller_transfer_fee,
                                                     maintenanceFee: property.maintenance_fee,
                                                     occupancyStatus: property.occupancy_status,
                                                     postedBy: property.posted_by
                                                     
                    )
                    let response = ProductDetailsViewModel.GetProductDetailsRequest.Response(
                        advObject: propertyList)
                    completion(response, nil) // Provide an array of CategoryListModel and nil for the error
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
    
    func insertToFavourite(productId: Int, isLike: Bool ,type: String, completion: @escaping (Bool?, Error?) -> Void) {
        
        let jsonObject: [String: Any?] = [
            "like": isLike,
            "itemId": productId,
            "type": type
        ].removeNullValues
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.sortedKeys]) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Insert Fav Request", Config.emptyData + jsonString)
                (Config.emptyData + jsonString).createSignature()
            }
        }
        
        Network.shared.apollo.perform(mutation: GQLK.Add_favoriteMutation(like: isLike, itemId: productId.graphQLNullable, type: type.graphQLNullable)) { result in
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

