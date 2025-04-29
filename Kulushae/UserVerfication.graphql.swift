// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class UserVerficationMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation UserVerfication($value: String, $type: String) {
      userVerfication(value: $value, type: $type) {
        __typename
        isExist
        status
        token
      }
    }
    """

  public let operationName: String = "UserVerfication"

  public var value: String?
  public var type: String?

  public init(value: String? = nil, type: String? = nil) {
    self.value = value
    self.type = type
  }

  public var variables: GraphQLMap? {
    return ["value": value, "type": type]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("userVerfication", arguments: ["value": GraphQLVariable("value"), "type": GraphQLVariable("type")], type: .object(UserVerfication.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(userVerfication: UserVerfication? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "userVerfication": userVerfication.flatMap { (value: UserVerfication) -> ResultMap in value.resultMap }])
    }

    public var userVerfication: UserVerfication? {
      get {
        return (resultMap["userVerfication"] as? ResultMap).flatMap { UserVerfication(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "userVerfication")
      }
    }

    public struct UserVerfication: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["UserVerficationResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("isExist", type: .scalar(Bool.self)),
          GraphQLField("status", type: .scalar(String.self)),
          GraphQLField("token", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(isExist: Bool? = nil, status: String? = nil, token: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "UserVerficationResponse", "isExist": isExist, "status": status, "token": token])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var isExist: Bool? {
        get {
          return resultMap["isExist"] as? Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "isExist")
        }
      }

      public var status: String? {
        get {
          return resultMap["status"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "status")
        }
      }

      public var token: String? {
        get {
          return resultMap["token"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "token")
        }
      }
    }
  }
}
