// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class UpdatePasswordMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation UpdatePassword($password: String!) {
      updatePassword(password: $password) {
        __typename
        message
        status
      }
    }
    """

  public let operationName: String = "UpdatePassword"

  public var password: String

  public init(password: String) {
    self.password = password
  }

  public var variables: GraphQLMap? {
    return ["password": password]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("updatePassword", arguments: ["password": GraphQLVariable("password")], type: .object(UpdatePassword.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(updatePassword: UpdatePassword? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "updatePassword": updatePassword.flatMap { (value: UpdatePassword) -> ResultMap in value.resultMap }])
    }

    public var updatePassword: UpdatePassword? {
      get {
        return (resultMap["updatePassword"] as? ResultMap).flatMap { UpdatePassword(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "updatePassword")
      }
    }

    public struct UpdatePassword: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Response"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("message", type: .scalar(String.self)),
          GraphQLField("status", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(message: String? = nil, status: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Response", "message": message, "status": status])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var message: String? {
        get {
          return resultMap["message"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "message")
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
    }
  }
}
