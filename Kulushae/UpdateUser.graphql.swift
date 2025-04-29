// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class UpdateUserMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation UpdateUser($userId: Int, $values: JSON) {
      updateUser(user_id: $userId, values: $values) {
        __typename
        id
        image
        first_name
        last_name
        email
        phone
        createdAt
      }
    }
    """

  public let operationName: String = "UpdateUser"

  public var userId: Int?
  public var values: String?

  public init(userId: Int? = nil, values: String? = nil) {
    self.userId = userId
    self.values = values
  }

  public var variables: GraphQLMap? {
    return ["userId": userId, "values": values]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("updateUser", arguments: ["user_id": GraphQLVariable("userId"), "values": GraphQLVariable("values")], type: .object(UpdateUser.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(updateUser: UpdateUser? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "updateUser": updateUser.flatMap { (value: UpdateUser) -> ResultMap in value.resultMap }])
    }

    public var updateUser: UpdateUser? {
      get {
        return (resultMap["updateUser"] as? ResultMap).flatMap { UpdateUser(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "updateUser")
      }
    }

    public struct UpdateUser: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["User"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .scalar(GraphQLID.self)),
          GraphQLField("image", type: .scalar(String.self)),
          GraphQLField("first_name", type: .scalar(String.self)),
          GraphQLField("last_name", type: .scalar(String.self)),
          GraphQLField("email", type: .scalar(String.self)),
          GraphQLField("phone", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID? = nil, image: String? = nil, firstName: String? = nil, lastName: String? = nil, email: String? = nil, phone: String? = nil, createdAt: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "User", "id": id, "image": image, "first_name": firstName, "last_name": lastName, "email": email, "phone": phone, "createdAt": createdAt])
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

      public var image: String? {
        get {
          return resultMap["image"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "image")
        }
      }

      public var firstName: String? {
        get {
          return resultMap["first_name"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "first_name")
        }
      }

      public var lastName: String? {
        get {
          return resultMap["last_name"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "last_name")
        }
      }

      public var email: String? {
        get {
          return resultMap["email"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "email")
        }
      }

      public var phone: String? {
        get {
          return resultMap["phone"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "phone")
        }
      }

      public var createdAt: String? {
        get {
          return resultMap["createdAt"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "createdAt")
        }
      }
    }
  }
}
