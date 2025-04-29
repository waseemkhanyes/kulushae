// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class PropertiesQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Properties($page: Int, $userId: Int, $filters: JSON, $categoryId: Int) {
      properties(page: $page, user_id: $userId, filters: $filters, category_id: $categoryId) {
        __typename
        data {
          __typename
          id
          title
          size
          bedrooms
          bathrooms
          neighbourhood
          location
          category_id
          images {
            __typename
            id
            image
          }
          price
          user_id {
            __typename
            id
          }
          is_featured
          is_favorite
          type
        }
        current_page
        per_page
        total
      }
    }
    """

  public let operationName: String = "Properties"

  public var page: Int?
  public var userId: Int?
  public var filters: String?
  public var categoryId: Int?

  public init(page: Int? = nil, userId: Int? = nil, filters: String? = nil, categoryId: Int? = nil) {
    self.page = page
    self.userId = userId
    self.filters = filters
    self.categoryId = categoryId
  }

  public var variables: GraphQLMap? {
    return ["page": page, "userId": userId, "filters": filters, "categoryId": categoryId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("properties", arguments: ["page": GraphQLVariable("page"), "user_id": GraphQLVariable("userId"), "filters": GraphQLVariable("filters"), "category_id": GraphQLVariable("categoryId")], type: .object(Property.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(properties: Property? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "properties": properties.flatMap { (value: Property) -> ResultMap in value.resultMap }])
    }

    public var properties: Property? {
      get {
        return (resultMap["properties"] as? ResultMap).flatMap { Property(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "properties")
      }
    }

    public struct Property: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["PropertiesResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("data", type: .nonNull(.list(.object(Datum.selections)))),
          GraphQLField("current_page", type: .scalar(String.self)),
          GraphQLField("per_page", type: .scalar(String.self)),
          GraphQLField("total", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(data: [Datum?], currentPage: String? = nil, perPage: String? = nil, total: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "PropertiesResponse", "data": data.map { (value: Datum?) -> ResultMap? in value.flatMap { (value: Datum) -> ResultMap in value.resultMap } }, "current_page": currentPage, "per_page": perPage, "total": total])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
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

      public struct Datum: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Property"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(Int.self))),
            GraphQLField("title", type: .scalar(String.self)),
            GraphQLField("size", type: .nonNull(.scalar(String.self))),
            GraphQLField("bedrooms", type: .nonNull(.scalar(String.self))),
            GraphQLField("bathrooms", type: .nonNull(.scalar(String.self))),
            GraphQLField("neighbourhood", type: .nonNull(.scalar(String.self))),
            GraphQLField("location", type: .nonNull(.scalar(String.self))),
            GraphQLField("category_id", type: .nonNull(.scalar(Int.self))),
            GraphQLField("images", type: .list(.object(Image.selections))),
            GraphQLField("price", type: .scalar(Double.self)),
            GraphQLField("user_id", type: .object(UserId.selections)),
            GraphQLField("is_featured", type: .scalar(Bool.self)),
            GraphQLField("is_favorite", type: .scalar(Bool.self)),
            GraphQLField("type", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: Int, title: String? = nil, size: String, bedrooms: String, bathrooms: String, neighbourhood: String, location: String, categoryId: Int, images: [Image?]? = nil, price: Double? = nil, userId: UserId? = nil, isFeatured: Bool? = nil, isFavorite: Bool? = nil, type: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "Property", "id": id, "title": title, "size": size, "bedrooms": bedrooms, "bathrooms": bathrooms, "neighbourhood": neighbourhood, "location": location, "category_id": categoryId, "images": images.flatMap { (value: [Image?]) -> [ResultMap?] in value.map { (value: Image?) -> ResultMap? in value.flatMap { (value: Image) -> ResultMap in value.resultMap } } }, "price": price, "user_id": userId.flatMap { (value: UserId) -> ResultMap in value.resultMap }, "is_featured": isFeatured, "is_favorite": isFavorite, "type": type])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: Int {
          get {
            return resultMap["id"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
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

        public var size: String {
          get {
            return resultMap["size"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "size")
          }
        }

        public var bedrooms: String {
          get {
            return resultMap["bedrooms"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "bedrooms")
          }
        }

        public var bathrooms: String {
          get {
            return resultMap["bathrooms"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "bathrooms")
          }
        }

        public var neighbourhood: String {
          get {
            return resultMap["neighbourhood"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "neighbourhood")
          }
        }

        public var location: String {
          get {
            return resultMap["location"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "location")
          }
        }

        public var categoryId: Int {
          get {
            return resultMap["category_id"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "category_id")
          }
        }

        public var images: [Image?]? {
          get {
            return (resultMap["images"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Image?] in value.map { (value: ResultMap?) -> Image? in value.flatMap { (value: ResultMap) -> Image in Image(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Image?]) -> [ResultMap?] in value.map { (value: Image?) -> ResultMap? in value.flatMap { (value: Image) -> ResultMap in value.resultMap } } }, forKey: "images")
          }
        }

        public var price: Double? {
          get {
            return resultMap["price"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "price")
          }
        }

        public var userId: UserId? {
          get {
            return (resultMap["user_id"] as? ResultMap).flatMap { UserId(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "user_id")
          }
        }

        public var isFeatured: Bool? {
          get {
            return resultMap["is_featured"] as? Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "is_featured")
          }
        }

        public var isFavorite: Bool? {
          get {
            return resultMap["is_favorite"] as? Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "is_favorite")
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

        public struct Image: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Image"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .scalar(GraphQLID.self)),
              GraphQLField("image", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID? = nil, image: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "Image", "id": id, "image": image])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID? {
            get {
              return resultMap["id"] as? GraphQLID
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
        }

        public struct UserId: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["PropertyUser"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID) {
            self.init(unsafeResultMap: ["__typename": "PropertyUser", "id": id])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: GraphQLID {
            get {
              return resultMap["id"]! as! GraphQLID
            }
            set {
              resultMap.updateValue(newValue, forKey: "id")
            }
          }
        }
      }
    }
  }
}
