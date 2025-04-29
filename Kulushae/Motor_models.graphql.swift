// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class MotorModelsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Motor_models($makeId: Int) {
      motor_models(make_id: $makeId) {
        __typename
        id
        motor_make_id
        title
      }
    }
    """

  public let operationName: String = "Motor_models"

  public var makeId: Int?

  public init(makeId: Int? = nil) {
    self.makeId = makeId
  }

  public var variables: GraphQLMap? {
    return ["makeId": makeId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("motor_models", arguments: ["make_id": GraphQLVariable("makeId")], type: .list(.object(MotorModel.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(motorModels: [MotorModel?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "motor_models": motorModels.flatMap { (value: [MotorModel?]) -> [ResultMap?] in value.map { (value: MotorModel?) -> ResultMap? in value.flatMap { (value: MotorModel) -> ResultMap in value.resultMap } } }])
    }

    public var motorModels: [MotorModel?]? {
      get {
        return (resultMap["motor_models"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [MotorModel?] in value.map { (value: ResultMap?) -> MotorModel? in value.flatMap { (value: ResultMap) -> MotorModel in MotorModel(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [MotorModel?]) -> [ResultMap?] in value.map { (value: MotorModel?) -> ResultMap? in value.flatMap { (value: MotorModel) -> ResultMap in value.resultMap } } }, forKey: "motor_models")
      }
    }

    public struct MotorModel: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MotorModel"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .scalar(GraphQLID.self)),
          GraphQLField("motor_make_id", type: .scalar(Int.self)),
          GraphQLField("title", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID? = nil, motorMakeId: Int? = nil, title: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "MotorModel", "id": id, "motor_make_id": motorMakeId, "title": title])
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

      public var motorMakeId: Int? {
        get {
          return resultMap["motor_make_id"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "motor_make_id")
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
