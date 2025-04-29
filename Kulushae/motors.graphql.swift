// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class MotorsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Motors($page: Int, $userId: Int, $categoryId: Int, $filters: JSON) {
      motors(page: $page, user_id: $userId, category_id: $categoryId, filters: $filters) {
        __typename
        current_page
        per_page
        total
        data {
          __typename
          id
          emirates
          trim
          specs
          year
          kilometers
          insured_in_uae
          price
          contact_info
          title
          desc
          tour_url
          fuel_type
          exterior_color
          interior_color
          warranty
          doors
          no_of_cylinders
          body_type
          seating_capacity
          horsepwer
          engine_capacity
          steering_side
          seller
          extras {
            __typename
            id
            title
          }
          images {
            __typename
            id
            image
          }
          type
          is_favorite
          is_featured
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
          category_id
          transmission_type
          make
          model
        }
      }
    }
    """

  public let operationName: String = "Motors"

  public var page: Int?
  public var userId: Int?
  public var categoryId: Int?
  public var filters: String?

  public init(page: Int? = nil, userId: Int? = nil, categoryId: Int? = nil, filters: String? = nil) {
    self.page = page
    self.userId = userId
    self.categoryId = categoryId
    self.filters = filters
  }

  public var variables: GraphQLMap? {
    return ["page": page, "userId": userId, "categoryId": categoryId, "filters": filters]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("motors", arguments: ["page": GraphQLVariable("page"), "user_id": GraphQLVariable("userId"), "category_id": GraphQLVariable("categoryId"), "filters": GraphQLVariable("filters")], type: .object(Motor.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(motors: Motor? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "motors": motors.flatMap { (value: Motor) -> ResultMap in value.resultMap }])
    }

    public var motors: Motor? {
      get {
        return (resultMap["motors"] as? ResultMap).flatMap { Motor(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "motors")
      }
    }

    public struct Motor: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MotorsResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("current_page", type: .scalar(String.self)),
          GraphQLField("per_page", type: .scalar(String.self)),
          GraphQLField("total", type: .scalar(String.self)),
          GraphQLField("data", type: .list(.object(Datum.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(currentPage: String? = nil, perPage: String? = nil, total: String? = nil, data: [Datum?]? = nil) {
        self.init(unsafeResultMap: ["__typename": "MotorsResponse", "current_page": currentPage, "per_page": perPage, "total": total, "data": data.flatMap { (value: [Datum?]) -> [ResultMap?] in value.map { (value: Datum?) -> ResultMap? in value.flatMap { (value: Datum) -> ResultMap in value.resultMap } } }])
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

      public var data: [Datum?]? {
        get {
          return (resultMap["data"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Datum?] in value.map { (value: ResultMap?) -> Datum? in value.flatMap { (value: ResultMap) -> Datum in Datum(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Datum?]) -> [ResultMap?] in value.map { (value: Datum?) -> ResultMap? in value.flatMap { (value: Datum) -> ResultMap in value.resultMap } } }, forKey: "data")
        }
      }

      public struct Datum: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Motor"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(Int.self))),
            GraphQLField("emirates", type: .scalar(String.self)),
            GraphQLField("trim", type: .scalar(String.self)),
            GraphQLField("specs", type: .scalar(String.self)),
            GraphQLField("year", type: .scalar(String.self)),
            GraphQLField("kilometers", type: .scalar(String.self)),
            GraphQLField("insured_in_uae", type: .scalar(Bool.self)),
            GraphQLField("price", type: .scalar(Double.self)),
            GraphQLField("contact_info", type: .scalar(String.self)),
            GraphQLField("title", type: .scalar(String.self)),
            GraphQLField("desc", type: .scalar(String.self)),
            GraphQLField("tour_url", type: .scalar(String.self)),
            GraphQLField("fuel_type", type: .scalar(String.self)),
            GraphQLField("exterior_color", type: .scalar(String.self)),
            GraphQLField("interior_color", type: .scalar(String.self)),
            GraphQLField("warranty", type: .scalar(String.self)),
            GraphQLField("doors", type: .scalar(String.self)),
            GraphQLField("no_of_cylinders", type: .scalar(String.self)),
            GraphQLField("body_type", type: .scalar(String.self)),
            GraphQLField("seating_capacity", type: .scalar(String.self)),
            GraphQLField("horsepwer", type: .scalar(String.self)),
            GraphQLField("engine_capacity", type: .scalar(String.self)),
            GraphQLField("steering_side", type: .scalar(String.self)),
            GraphQLField("seller", type: .scalar(String.self)),
            GraphQLField("extras", type: .list(.object(Extra.selections))),
            GraphQLField("images", type: .list(.object(Image.selections))),
            GraphQLField("type", type: .scalar(String.self)),
            GraphQLField("is_favorite", type: .scalar(Bool.self)),
            GraphQLField("is_featured", type: .scalar(Bool.self)),
            GraphQLField("user_id", type: .object(UserId.selections)),
            GraphQLField("category_id", type: .scalar(Int.self)),
            GraphQLField("transmission_type", type: .scalar(String.self)),
            GraphQLField("make", type: .scalar(String.self)),
            GraphQLField("model", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: Int, emirates: String? = nil, trim: String? = nil, specs: String? = nil, year: String? = nil, kilometers: String? = nil, insuredInUae: Bool? = nil, price: Double? = nil, contactInfo: String? = nil, title: String? = nil, desc: String? = nil, tourUrl: String? = nil, fuelType: String? = nil, exteriorColor: String? = nil, interiorColor: String? = nil, warranty: String? = nil, doors: String? = nil, noOfCylinders: String? = nil, bodyType: String? = nil, seatingCapacity: String? = nil, horsepwer: String? = nil, engineCapacity: String? = nil, steeringSide: String? = nil, seller: String? = nil, extras: [Extra?]? = nil, images: [Image?]? = nil, type: String? = nil, isFavorite: Bool? = nil, isFeatured: Bool? = nil, userId: UserId? = nil, categoryId: Int? = nil, transmissionType: String? = nil, make: String? = nil, model: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "Motor", "id": id, "emirates": emirates, "trim": trim, "specs": specs, "year": year, "kilometers": kilometers, "insured_in_uae": insuredInUae, "price": price, "contact_info": contactInfo, "title": title, "desc": desc, "tour_url": tourUrl, "fuel_type": fuelType, "exterior_color": exteriorColor, "interior_color": interiorColor, "warranty": warranty, "doors": doors, "no_of_cylinders": noOfCylinders, "body_type": bodyType, "seating_capacity": seatingCapacity, "horsepwer": horsepwer, "engine_capacity": engineCapacity, "steering_side": steeringSide, "seller": seller, "extras": extras.flatMap { (value: [Extra?]) -> [ResultMap?] in value.map { (value: Extra?) -> ResultMap? in value.flatMap { (value: Extra) -> ResultMap in value.resultMap } } }, "images": images.flatMap { (value: [Image?]) -> [ResultMap?] in value.map { (value: Image?) -> ResultMap? in value.flatMap { (value: Image) -> ResultMap in value.resultMap } } }, "type": type, "is_favorite": isFavorite, "is_featured": isFeatured, "user_id": userId.flatMap { (value: UserId) -> ResultMap in value.resultMap }, "category_id": categoryId, "transmission_type": transmissionType, "make": make, "model": model])
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

        public var emirates: String? {
          get {
            return resultMap["emirates"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "emirates")
          }
        }

        public var trim: String? {
          get {
            return resultMap["trim"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "trim")
          }
        }

        public var specs: String? {
          get {
            return resultMap["specs"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "specs")
          }
        }

        public var year: String? {
          get {
            return resultMap["year"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "year")
          }
        }

        public var kilometers: String? {
          get {
            return resultMap["kilometers"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "kilometers")
          }
        }

        public var insuredInUae: Bool? {
          get {
            return resultMap["insured_in_uae"] as? Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "insured_in_uae")
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

        public var contactInfo: String? {
          get {
            return resultMap["contact_info"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "contact_info")
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

        public var desc: String? {
          get {
            return resultMap["desc"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "desc")
          }
        }

        public var tourUrl: String? {
          get {
            return resultMap["tour_url"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "tour_url")
          }
        }

        public var fuelType: String? {
          get {
            return resultMap["fuel_type"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "fuel_type")
          }
        }

        public var exteriorColor: String? {
          get {
            return resultMap["exterior_color"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "exterior_color")
          }
        }

        public var interiorColor: String? {
          get {
            return resultMap["interior_color"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "interior_color")
          }
        }

        public var warranty: String? {
          get {
            return resultMap["warranty"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "warranty")
          }
        }

        public var doors: String? {
          get {
            return resultMap["doors"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "doors")
          }
        }

        public var noOfCylinders: String? {
          get {
            return resultMap["no_of_cylinders"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "no_of_cylinders")
          }
        }

        public var bodyType: String? {
          get {
            return resultMap["body_type"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "body_type")
          }
        }

        public var seatingCapacity: String? {
          get {
            return resultMap["seating_capacity"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "seating_capacity")
          }
        }

        public var horsepwer: String? {
          get {
            return resultMap["horsepwer"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "horsepwer")
          }
        }

        public var engineCapacity: String? {
          get {
            return resultMap["engine_capacity"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "engine_capacity")
          }
        }

        public var steeringSide: String? {
          get {
            return resultMap["steering_side"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "steering_side")
          }
        }

        public var seller: String? {
          get {
            return resultMap["seller"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "seller")
          }
        }

        public var extras: [Extra?]? {
          get {
            return (resultMap["extras"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Extra?] in value.map { (value: ResultMap?) -> Extra? in value.flatMap { (value: ResultMap) -> Extra in Extra(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Extra?]) -> [ResultMap?] in value.map { (value: Extra?) -> ResultMap? in value.flatMap { (value: Extra) -> ResultMap in value.resultMap } } }, forKey: "extras")
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

        public var type: String? {
          get {
            return resultMap["type"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "type")
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

        public var isFeatured: Bool? {
          get {
            return resultMap["is_featured"] as? Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "is_featured")
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

        public var categoryId: Int? {
          get {
            return resultMap["category_id"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "category_id")
          }
        }

        public var transmissionType: String? {
          get {
            return resultMap["transmission_type"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "transmission_type")
          }
        }

        public var make: String? {
          get {
            return resultMap["make"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "make")
          }
        }

        public var model: String? {
          get {
            return resultMap["model"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "model")
          }
        }

        public struct Extra: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Extra"]

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
            self.init(unsafeResultMap: ["__typename": "Extra", "id": id, "title": title])
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

        public struct UserId: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["MotorUser"]

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
            self.init(unsafeResultMap: ["__typename": "MotorUser", "id": id, "image": image, "first_name": firstName, "last_name": lastName, "email": email, "phone": phone, "member_since": memberSince, "total_listings": totalListings])
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
}
