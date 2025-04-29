// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class SearchQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Search($value: String) {
      search(value: $value) {
        __typename
        ads
        category
        category_id
        title
        type
      }
    }
    """

  public let operationName: String = "Search"

  public var value: String?

  public init(value: String? = nil) {
    self.value = value
  }

  public var variables: GraphQLMap? {
    return ["value": value]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("search", arguments: ["value": GraphQLVariable("value")], type: .list(.object(Search.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(search: [Search?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "search": search.flatMap { (value: [Search?]) -> [ResultMap?] in value.map { (value: Search?) -> ResultMap? in value.flatMap { (value: Search) -> ResultMap in value.resultMap } } }])
    }

    public var search: [Search?]? {
      get {
        return (resultMap["search"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Search?] in value.map { (value: ResultMap?) -> Search? in value.flatMap { (value: ResultMap) -> Search in Search(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [Search?]) -> [ResultMap?] in value.map { (value: Search?) -> ResultMap? in value.flatMap { (value: Search) -> ResultMap in value.resultMap } } }, forKey: "search")
      }
    }

    public struct Search: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["SearchResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("ads", type: .scalar(Int.self)),
          GraphQLField("category", type: .scalar(String.self)),
          GraphQLField("category_id", type: .scalar(Int.self)),
          GraphQLField("title", type: .scalar(String.self)),
          GraphQLField("type", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(ads: Int? = nil, category: String? = nil, categoryId: Int? = nil, title: String? = nil, type: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "SearchResponse", "ads": ads, "category": category, "category_id": categoryId, "title": title, "type": type])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var ads: Int? {
        get {
          return resultMap["ads"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "ads")
        }
      }

      public var category: String? {
        get {
          return resultMap["category"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "category")
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
    }
  }
}
