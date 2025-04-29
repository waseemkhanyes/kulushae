// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class CountryQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Country($countryId: Int) {
      country(id: $countryId) {
        __typename
        id
        iso3
        name
      }
    }
    """

  public let operationName: String = "Country"

  public var countryId: Int?

  public init(countryId: Int? = nil) {
    self.countryId = countryId
  }

  public var variables: GraphQLMap? {
    return ["countryId": countryId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("country", arguments: ["id": GraphQLVariable("countryId")], type: .object(Country.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(country: Country? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "country": country.flatMap { (value: Country) -> ResultMap in value.resultMap }])
    }

    public var country: Country? {
      get {
        return (resultMap["country"] as? ResultMap).flatMap { Country(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "country")
      }
    }

    public struct Country: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Country"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("iso3", type: .scalar(String.self)),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, iso3: String? = nil, name: String) {
        self.init(unsafeResultMap: ["__typename": "Country", "id": id, "iso3": iso3, "name": name])
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

      public var iso3: String? {
        get {
          return resultMap["iso3"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "iso3")
        }
      }

      public var name: String {
        get {
          return resultMap["name"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }
    }
  }
}
