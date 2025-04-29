// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class FavouritesQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Favourites($userId: Int, $page: Int) {
      favourites(user_id: $userId, page: $page) {
        __typename
        current_page
        per_page
        total
        data {
          __typename
          id
          image
          size
          location
          title
          type
          user_id
          bathrooms
          bedrooms
          price
          car_year
          car_steering
          car_specs
          car_kilometers
        }
      }
    }
    """

  public let operationName: String = "Favourites"

  public var userId: Int?
  public var page: Int?

  public init(userId: Int? = nil, page: Int? = nil) {
    self.userId = userId
    self.page = page
  }

  public var variables: GraphQLMap? {
    return ["userId": userId, "page": page]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("favourites", arguments: ["user_id": GraphQLVariable("userId"), "page": GraphQLVariable("page")], type: .object(Favourite.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(favourites: Favourite? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "favourites": favourites.flatMap { (value: Favourite) -> ResultMap in value.resultMap }])
    }

    public var favourites: Favourite? {
      get {
        return (resultMap["favourites"] as? ResultMap).flatMap { Favourite(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "favourites")
      }
    }

    public struct Favourite: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["UserFavourites"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("current_page", type: .scalar(String.self)),
          GraphQLField("per_page", type: .scalar(String.self)),
          GraphQLField("total", type: .scalar(String.self)),
          GraphQLField("data", type: .nonNull(.list(.object(Datum.selections)))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(currentPage: String? = nil, perPage: String? = nil, total: String? = nil, data: [Datum?]) {
        self.init(unsafeResultMap: ["__typename": "UserFavourites", "current_page": currentPage, "per_page": perPage, "total": total, "data": data.map { (value: Datum?) -> ResultMap? in value.flatMap { (value: Datum) -> ResultMap in value.resultMap } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var currentPage: String? {
        get {
          return resultMap["current_page"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "current_page")
        }
      }

      public var perPage: String? {
        get {
          return resultMap["per_page"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "per_page")
        }
      }

      public var total: String? {
        get {
          return resultMap["total"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "total")
        }
      }

      public var data: [Datum?] {
        get {
          return (resultMap["data"] as! [ResultMap?]).map { (value: ResultMap?) -> Datum? in value.flatMap { (value: ResultMap) -> Datum in Datum(unsafeResultMap: value) } }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Datum?) -> ResultMap? in value.flatMap { (value: Datum) -> ResultMap in value.resultMap } }, forKey: "data")
        }
      }

      public struct Datum: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Favourite"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .scalar(Int.self)),
            GraphQLField("image", type: .scalar(String.self)),
            GraphQLField("size", type: .scalar(String.self)),
            GraphQLField("location", type: .scalar(String.self)),
            GraphQLField("title", type: .scalar(String.self)),
            GraphQLField("type", type: .scalar(String.self)),
            GraphQLField("user_id", type: .scalar(Int.self)),
            GraphQLField("bathrooms", type: .scalar(String.self)),
            GraphQLField("bedrooms", type: .scalar(String.self)),
            GraphQLField("price", type: .scalar(String.self)),
            GraphQLField("car_year", type: .scalar(String.self)),
            GraphQLField("car_steering", type: .scalar(String.self)),
            GraphQLField("car_specs", type: .scalar(String.self)),
            GraphQLField("car_kilometers", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: Int? = nil, image: String? = nil, size: String? = nil, location: String? = nil, title: String? = nil, type: String? = nil, userId: Int? = nil, bathrooms: String? = nil, bedrooms: String? = nil, price: String? = nil, carYear: String? = nil, carSteering: String? = nil, carSpecs: String? = nil, carKilometers: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "Favourite", "id": id, "image": image, "size": size, "location": location, "title": title, "type": type, "user_id": userId, "bathrooms": bathrooms, "bedrooms": bedrooms, "price": price, "car_year": carYear, "car_steering": carSteering, "car_specs": carSpecs, "car_kilometers": carKilometers])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: Int? {
          get {
            return resultMap["id"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var image: String? {
          get {
            return resultMap["image"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "image")
          }
        }

        public var size: String? {
          get {
            return resultMap["size"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "size")
          }
        }

        public var location: String? {
          get {
            return resultMap["location"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "location")
          }
        }

        public var title: String? {
          get {
            return resultMap["title"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "title")
          }
        }

        public var type: String? {
          get {
            return resultMap["type"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "type")
          }
        }

        public var userId: Int? {
          get {
            return resultMap["user_id"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "user_id")
          }
        }

        public var bathrooms: String? {
          get {
            return resultMap["bathrooms"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "bathrooms")
          }
        }

        public var bedrooms: String? {
          get {
            return resultMap["bedrooms"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "bedrooms")
          }
        }

        public var price: String? {
          get {
            return resultMap["price"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "price")
          }
        }

        public var carYear: String? {
          get {
            return resultMap["car_year"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "car_year")
          }
        }

        public var carSteering: String? {
          get {
            return resultMap["car_steering"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "car_steering")
          }
        }

        public var carSpecs: String? {
          get {
            return resultMap["car_specs"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "car_specs")
          }
        }

        public var carKilometers: String? {
          get {
            return resultMap["car_kilometers"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "car_kilometers")
          }
        }
      }
    }
  }
}
