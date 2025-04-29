// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class CountriesQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Countries {
      countries {
        __typename
        id
        iso3
        name
        states {
          __typename
          id
          name
        }
      }
    }
    """

  public let operationName: String = "Countries"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("countries", type: .nonNull(.list(.nonNull(.object(Country.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(countries: [Country]) {
      self.init(unsafeResultMap: ["__typename": "Query", "countries": countries.map { (value: Country) -> ResultMap in value.resultMap }])
    }

    public var countries: [Country] {
      get {
        return (resultMap["countries"] as! [ResultMap]).map { (value: ResultMap) -> Country in Country(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: Country) -> ResultMap in value.resultMap }, forKey: "countries")
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
          GraphQLField("states", type: .list(.object(State.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, iso3: String? = nil, name: String, states: [State?]? = nil) {
        self.init(unsafeResultMap: ["__typename": "Country", "id": id, "iso3": iso3, "name": name, "states": states.flatMap { (value: [State?]) -> [ResultMap?] in value.map { (value: State?) -> ResultMap? in value.flatMap { (value: State) -> ResultMap in value.resultMap } } }])
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

      public var states: [State?]? {
        get {
          return (resultMap["states"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [State?] in value.map { (value: ResultMap?) -> State? in value.flatMap { (value: ResultMap) -> State in State(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [State?]) -> [ResultMap?] in value.map { (value: State?) -> ResultMap? in value.flatMap { (value: State) -> ResultMap in value.resultMap } } }, forKey: "states")
        }
      }

      public struct State: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["State"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("name", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, name: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "State", "id": id, "name": name])
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

        public var name: String? {
          get {
            return resultMap["name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }
      }
    }
  }
}
