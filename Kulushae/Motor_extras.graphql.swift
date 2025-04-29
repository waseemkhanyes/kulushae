// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class MotorExtrasQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Motor_extras {
      motor_extras {
        __typename
        id
        title
      }
    }
    """

  public let operationName: String = "Motor_extras"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("motor_extras", type: .list(.object(MotorExtra.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(motorExtras: [MotorExtra?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "motor_extras": motorExtras.flatMap { (value: [MotorExtra?]) -> [ResultMap?] in value.map { (value: MotorExtra?) -> ResultMap? in value.flatMap { (value: MotorExtra) -> ResultMap in value.resultMap } } }])
    }

    public var motorExtras: [MotorExtra?]? {
      get {
        return (resultMap["motor_extras"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [MotorExtra?] in value.map { (value: ResultMap?) -> MotorExtra? in value.flatMap { (value: ResultMap) -> MotorExtra in MotorExtra(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [MotorExtra?]) -> [ResultMap?] in value.map { (value: MotorExtra?) -> ResultMap? in value.flatMap { (value: MotorExtra) -> ResultMap in value.resultMap } } }, forKey: "motor_extras")
      }
    }

    public struct MotorExtra: GraphQLSelectionSet {
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
  }
}
