// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class DeleteUserMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation DeleteUser {
      deleteUser {
        __typename
        status
        message
      }
    }
    """

  public let operationName: String = "DeleteUser"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("deleteUser", type: .object(DeleteUser.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(deleteUser: DeleteUser? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "deleteUser": deleteUser.flatMap { (value: DeleteUser) -> ResultMap in value.resultMap }])
    }

    public var deleteUser: DeleteUser? {
      get {
        return (resultMap["deleteUser"] as? ResultMap).flatMap { DeleteUser(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "deleteUser")
      }
    }

    public struct DeleteUser: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Response"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("status", type: .scalar(String.self)),
          GraphQLField("message", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(status: String? = nil, message: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Response", "status": status, "message": message])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
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

      public var message: String? {
        get {
          return resultMap["message"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "message")
        }
      }
    }
  }
}
