// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class UserAdsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query UserAds($userId: Int, $page: Int) {
      userAds(user_id: $userId, page: $page) {
        __typename
        current_page
        per_page
        total
        data {
          __typename
          id
          image
          title
          type
          user_id
        }
      }
    }
    """

  public let operationName: String = "UserAds"

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
        GraphQLField("userAds", arguments: ["user_id": GraphQLVariable("userId"), "page": GraphQLVariable("page")], type: .object(UserAd.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(userAds: UserAd? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "userAds": userAds.flatMap { (value: UserAd) -> ResultMap in value.resultMap }])
    }

    public var userAds: UserAd? {
      get {
        return (resultMap["userAds"] as? ResultMap).flatMap { UserAd(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "userAds")
      }
    }

    public struct UserAd: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["UserAds"]

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
        self.init(unsafeResultMap: ["__typename": "UserAds", "current_page": currentPage, "per_page": perPage, "total": total, "data": data.map { (value: Datum?) -> ResultMap? in value.flatMap { (value: Datum) -> ResultMap in value.resultMap } }])
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
        public static let possibleTypes: [String] = ["Ads"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .scalar(Int.self)),
            GraphQLField("image", type: .scalar(String.self)),
            GraphQLField("title", type: .scalar(String.self)),
            GraphQLField("type", type: .scalar(String.self)),
            GraphQLField("user_id", type: .scalar(Int.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: Int? = nil, image: String? = nil, title: String? = nil, type: String? = nil, userId: Int? = nil) {
          self.init(unsafeResultMap: ["__typename": "Ads", "id": id, "image": image, "title": title, "type": type, "user_id": userId])
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
      }
    }
  }
}
