// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class PropertyQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Property($propertyId: Int) {
      property(id: $propertyId) {
        __typename
        amenities {
          __typename
          id
          title
        }
        bathrooms
        bedrooms
        category_id
        contact_number
        description
        id
        images {
          __typename
          id
          image
        }
        location
        neighbourhood
        price
        size
        socialmedia {
          __typename
          id
          type
          value
        }
        title
        user_id {
          __typename
          id
          image
          first_name
          last_name
          email
          phone
          member_since
          total_listings
        }
        is_featured
        is_favorite
        type
      }
    }
    """

  public let operationName: String = "Property"

  public var propertyId: Int?

  public init(propertyId: Int? = nil) {
    self.propertyId = propertyId
  }

  public var variables: GraphQLMap? {
    return ["propertyId": propertyId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("property", arguments: ["id": GraphQLVariable("propertyId")], type: .object(Property.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(property: Property? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "property": property.flatMap { (value: Property) -> ResultMap in value.resultMap }])
    }

    public var property: Property? {
      get {
        return (resultMap["property"] as? ResultMap).flatMap { Property(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "property")
      }
    }

    public struct Property: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Property"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("amenities", type: .list(.object(Amenity.selections))),
          GraphQLField("bathrooms", type: .nonNull(.scalar(String.self))),
          GraphQLField("bedrooms", type: .nonNull(.scalar(String.self))),
          GraphQLField("category_id", type: .nonNull(.scalar(Int.self))),
          GraphQLField("contact_number", type: .nonNull(.scalar(String.self))),
          GraphQLField("description", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(Int.self))),
          GraphQLField("images", type: .list(.object(Image.selections))),
          GraphQLField("location", type: .nonNull(.scalar(String.self))),
          GraphQLField("neighbourhood", type: .nonNull(.scalar(String.self))),
          GraphQLField("price", type: .scalar(Double.self)),
          GraphQLField("size", type: .nonNull(.scalar(String.self))),
          GraphQLField("socialmedia", type: .list(.object(Socialmedium.selections))),
          GraphQLField("title", type: .scalar(String.self)),
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

      public init(amenities: [Amenity?]? = nil, bathrooms: String, bedrooms: String, categoryId: Int, contactNumber: String, description: String, id: Int, images: [Image?]? = nil, location: String, neighbourhood: String, price: Double? = nil, size: String, socialmedia: [Socialmedium?]? = nil, title: String? = nil, userId: UserId? = nil, isFeatured: Bool? = nil, isFavorite: Bool? = nil, type: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Property", "amenities": amenities.flatMap { (value: [Amenity?]) -> [ResultMap?] in value.map { (value: Amenity?) -> ResultMap? in value.flatMap { (value: Amenity) -> ResultMap in value.resultMap } } }, "bathrooms": bathrooms, "bedrooms": bedrooms, "category_id": categoryId, "contact_number": contactNumber, "description": description, "id": id, "images": images.flatMap { (value: [Image?]) -> [ResultMap?] in value.map { (value: Image?) -> ResultMap? in value.flatMap { (value: Image) -> ResultMap in value.resultMap } } }, "location": location, "neighbourhood": neighbourhood, "price": price, "size": size, "socialmedia": socialmedia.flatMap { (value: [Socialmedium?]) -> [ResultMap?] in value.map { (value: Socialmedium?) -> ResultMap? in value.flatMap { (value: Socialmedium) -> ResultMap in value.resultMap } } }, "title": title, "user_id": userId.flatMap { (value: UserId) -> ResultMap in value.resultMap }, "is_featured": isFeatured, "is_favorite": isFavorite, "type": type])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var amenities: [Amenity?]? {
        get {
          return (resultMap["amenities"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Amenity?] in value.map { (value: ResultMap?) -> Amenity? in value.flatMap { (value: ResultMap) -> Amenity in Amenity(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Amenity?]) -> [ResultMap?] in value.map { (value: Amenity?) -> ResultMap? in value.flatMap { (value: Amenity) -> ResultMap in value.resultMap } } }, forKey: "amenities")
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

      public var bedrooms: String {
        get {
          return resultMap["bedrooms"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "bedrooms")
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

      public var contactNumber: String {
        get {
          return resultMap["contact_number"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "contact_number")
        }
      }

      public var description: String {
        get {
          return resultMap["description"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "description")
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

      public var images: [Image?]? {
        get {
          return (resultMap["images"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Image?] in value.map { (value: ResultMap?) -> Image? in value.flatMap { (value: ResultMap) -> Image in Image(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Image?]) -> [ResultMap?] in value.map { (value: Image?) -> ResultMap? in value.flatMap { (value: Image) -> ResultMap in value.resultMap } } }, forKey: "images")
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

      public var neighbourhood: String {
        get {
          return resultMap["neighbourhood"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "neighbourhood")
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

      public var size: String {
        get {
          return resultMap["size"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "size")
        }
      }

      public var socialmedia: [Socialmedium?]? {
        get {
          return (resultMap["socialmedia"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Socialmedium?] in value.map { (value: ResultMap?) -> Socialmedium? in value.flatMap { (value: ResultMap) -> Socialmedium in Socialmedium(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Socialmedium?]) -> [ResultMap?] in value.map { (value: Socialmedium?) -> ResultMap? in value.flatMap { (value: Socialmedium) -> ResultMap in value.resultMap } } }, forKey: "socialmedia")
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

      public struct Amenity: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Amenity"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .scalar(GraphQLID.self)),
            GraphQLField("title", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID? = nil, title: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "Amenity", "id": id, "title": title])
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

        public var title: String? {
          get {
            return resultMap["title"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "title")
          }
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

      public struct Socialmedium: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["SocialMedia"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .scalar(GraphQLID.self)),
            GraphQLField("type", type: .scalar(String.self)),
            GraphQLField("value", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID? = nil, type: String? = nil, value: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "SocialMedia", "id": id, "type": type, "value": value])
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

        public var type: String? {
          get {
            return resultMap["type"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "type")
          }
        }

        public var value: String? {
          get {
            return resultMap["value"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "value")
          }
        }
      }

      public struct UserId: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["PropertyUser"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("image", type: .scalar(String.self)),
            GraphQLField("first_name", type: .scalar(String.self)),
            GraphQLField("last_name", type: .scalar(String.self)),
            GraphQLField("email", type: .scalar(String.self)),
            GraphQLField("phone", type: .scalar(String.self)),
            GraphQLField("member_since", type: .scalar(String.self)),
            GraphQLField("total_listings", type: .scalar(Int.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, image: String? = nil, firstName: String? = nil, lastName: String? = nil, email: String? = nil, phone: String? = nil, memberSince: String? = nil, totalListings: Int? = nil) {
          self.init(unsafeResultMap: ["__typename": "PropertyUser", "id": id, "image": image, "first_name": firstName, "last_name": lastName, "email": email, "phone": phone, "member_since": memberSince, "total_listings": totalListings])
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

        public var image: String? {
          get {
            return resultMap["image"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "image")
          }
        }

        public var firstName: String? {
          get {
            return resultMap["first_name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "first_name")
          }
        }

        public var lastName: String? {
          get {
            return resultMap["last_name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "last_name")
          }
        }

        public var email: String? {
          get {
            return resultMap["email"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "email")
          }
        }

        public var phone: String? {
          get {
            return resultMap["phone"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "phone")
          }
        }

        public var memberSince: String? {
          get {
            return resultMap["member_since"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "member_since")
          }
        }

        public var totalListings: Int? {
          get {
            return resultMap["total_listings"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "total_listings")
          }
        }
      }
    }
  }
}
