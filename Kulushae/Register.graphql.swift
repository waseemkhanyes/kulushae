// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class RegisterMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation Register($firstName: String, $lastName: String, $email: String, $phone: String, $type: String, $registerId: String, $deviceVersion: String, $deviceModel: String, $deviceMake: String, $deviceType: String, $deviceId: String, $fcmToken: String, $password: String) {
      register(first_name: $firstName, last_name: $lastName, email: $email, phone: $phone, type: $type, id: $registerId, device_version: $deviceVersion, device_model: $deviceModel, device_make: $deviceMake, device_type: $deviceType, device_id: $deviceId, fcm_token: $fcmToken, password: $password) {
        __typename
        user {
          __typename
          id
          image
          first_name
          last_name
          email
          phone
          is_premium
          createdAt
        }
        token
        refresh_token
        message
        status
      }
    }
    """

  public let operationName: String = "Register"

  public var firstName: String?
  public var lastName: String?
  public var email: String?
  public var phone: String?
  public var type: String?
  public var registerId: String?
  public var deviceVersion: String?
  public var deviceModel: String?
  public var deviceMake: String?
  public var deviceType: String?
  public var deviceId: String?
  public var fcmToken: String?
  public var password: String?

  public init(firstName: String? = nil, lastName: String? = nil, email: String? = nil, phone: String? = nil, type: String? = nil, registerId: String? = nil, deviceVersion: String? = nil, deviceModel: String? = nil, deviceMake: String? = nil, deviceType: String? = nil, deviceId: String? = nil, fcmToken: String? = nil, password: String? = nil) {
    self.firstName = firstName
    self.lastName = lastName
    self.email = email
    self.phone = phone
    self.type = type
    self.registerId = registerId
    self.deviceVersion = deviceVersion
    self.deviceModel = deviceModel
    self.deviceMake = deviceMake
    self.deviceType = deviceType
    self.deviceId = deviceId
    self.fcmToken = fcmToken
    self.password = password
  }

  public var variables: GraphQLMap? {
    return ["firstName": firstName, "lastName": lastName, "email": email, "phone": phone, "type": type, "registerId": registerId, "deviceVersion": deviceVersion, "deviceModel": deviceModel, "deviceMake": deviceMake, "deviceType": deviceType, "deviceId": deviceId, "fcmToken": fcmToken, "password": password]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("register", arguments: ["first_name": GraphQLVariable("firstName"), "last_name": GraphQLVariable("lastName"), "email": GraphQLVariable("email"), "phone": GraphQLVariable("phone"), "type": GraphQLVariable("type"), "id": GraphQLVariable("registerId"), "device_version": GraphQLVariable("deviceVersion"), "device_model": GraphQLVariable("deviceModel"), "device_make": GraphQLVariable("deviceMake"), "device_type": GraphQLVariable("deviceType"), "device_id": GraphQLVariable("deviceId"), "fcm_token": GraphQLVariable("fcmToken"), "password": GraphQLVariable("password")], type: .object(Register.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(register: Register? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "register": register.flatMap { (value: Register) -> ResultMap in value.resultMap }])
    }

    public var register: Register? {
      get {
        return (resultMap["register"] as? ResultMap).flatMap { Register(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "register")
      }
    }

    public struct Register: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Response"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("user", type: .object(User.selections)),
          GraphQLField("token", type: .scalar(String.self)),
          GraphQLField("refresh_token", type: .scalar(String.self)),
          GraphQLField("message", type: .scalar(String.self)),
          GraphQLField("status", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(user: User? = nil, token: String? = nil, refreshToken: String? = nil, message: String? = nil, status: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Response", "user": user.flatMap { (value: User) -> ResultMap in value.resultMap }, "token": token, "refresh_token": refreshToken, "message": message, "status": status])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var user: User? {
        get {
          return (resultMap["user"] as? ResultMap).flatMap { User(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "user")
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

      public var refreshToken: String? {
        get {
          return resultMap["refresh_token"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "refresh_token")
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

      public struct User: GraphQLSelectionSet {
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
            GraphQLField("is_premium", type: .scalar(Bool.self)),
            GraphQLField("createdAt", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID? = nil, image: String? = nil, firstName: String? = nil, lastName: String? = nil, email: String? = nil, phone: String? = nil, isPremium: Bool? = nil, createdAt: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "User", "id": id, "image": image, "first_name": firstName, "last_name": lastName, "email": email, "phone": phone, "is_premium": isPremium, "createdAt": createdAt])
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

        public var isPremium: Bool? {
          get {
            return resultMap["is_premium"] as? Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "is_premium")
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
}
