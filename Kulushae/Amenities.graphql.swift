// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class AmenitiesQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Amenities {
      amenities {
        __typename
        id
        title
      }
    }
    """

  public let operationName: String = "Amenities"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("amenities", type: .list(.object(Amenity.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(amenities: [Amenity?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "amenities": amenities.flatMap { (value: [Amenity?]) -> [ResultMap?] in value.map { (value: Amenity?) -> ResultMap? in value.flatMap { (value: Amenity) -> ResultMap in value.resultMap } } }])
    }

    public var amenities: [Amenity?]? {
      get {
        return (resultMap["amenities"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Amenity?] in value.map { (value: ResultMap?) -> Amenity? in value.flatMap { (value: ResultMap) -> Amenity in Amenity(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [Amenity?]) -> [ResultMap?] in value.map { (value: Amenity?) -> ResultMap? in value.flatMap { (value: Amenity) -> ResultMap in value.resultMap } } }, forKey: "amenities")
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
  }
}
