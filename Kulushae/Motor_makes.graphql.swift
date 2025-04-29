// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class MotorMakesQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Motor_makes {
      motor_makes {
        __typename
        id
        title
      }
    }
    """

  public let operationName: String = "Motor_makes"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("motor_makes", type: .list(.object(MotorMake.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(motorMakes: [MotorMake?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "motor_makes": motorMakes.flatMap { (value: [MotorMake?]) -> [ResultMap?] in value.map { (value: MotorMake?) -> ResultMap? in value.flatMap { (value: MotorMake) -> ResultMap in value.resultMap } } }])
    }

    public var motorMakes: [MotorMake?]? {
      get {
        return (resultMap["motor_makes"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [MotorMake?] in value.map { (value: ResultMap?) -> MotorMake? in value.flatMap { (value: ResultMap) -> MotorMake in MotorMake(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [MotorMake?]) -> [ResultMap?] in value.map { (value: MotorMake?) -> ResultMap? in value.flatMap { (value: MotorMake) -> ResultMap in value.resultMap } } }, forKey: "motor_makes")
      }
    }

    public struct MotorMake: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MotorMake"]

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
        self.init(unsafeResultMap: ["__typename": "MotorMake", "id": id, "title": title])
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
