// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class LoginMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation Login($fcmToken: String, $deviceId: String, $deviceType: String, $deviceMake: String, $deviceModel: String, $deviceVersion: String, $loginId: String, $type: String, $phone: String, $email: String, $password: String) {
      login(fcm_token: $fcmToken, device_id: $deviceId, device_type: $deviceType, device_make: $deviceMake, device_model: $deviceModel, device_version: $deviceVersion, id: $loginId, type: $type, phone: $phone, email: $email, password: $password) {
        __typename
        token
        refresh_token
        message
        status
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
      }
    }
    """

  public let operationName: String = "Login"

  public var fcmToken: String?
  public var deviceId: String?
  public var deviceType: String?
  public var deviceMake: String?
  public var deviceModel: String?
  public var deviceVersion: String?
  public var loginId: String?
  public var type: String?
  public var phone: String?
  public var email: String?
  public var password: String?

  public init(fcmToken: String? = nil, deviceId: String? = nil, deviceType: String? = nil, deviceMake: String? = nil, deviceModel: String? = nil, deviceVersion: String? = nil, loginId: String? = nil, type: String? = nil, phone: String? = nil, email: String? = nil, password: String? = nil) {
    self.fcmToken = fcmToken
    self.deviceId = deviceId
    self.deviceType = deviceType
    self.deviceMake = deviceMake
    self.deviceModel = deviceModel
    self.deviceVersion = deviceVersion
    self.loginId = loginId
    self.type = type
    self.phone = phone
    self.email = email
    self.password = password
  }

  public var variables: GraphQLMap? {
    return ["fcmToken": fcmToken, "deviceId": deviceId, "deviceType": deviceType, "deviceMake": deviceMake, "deviceModel": deviceModel, "deviceVersion": deviceVersion, "loginId": loginId, "type": type, "phone": phone, "email": email, "password": password]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("login", arguments: ["fcm_token": GraphQLVariable("fcmToken"), "device_id": GraphQLVariable("deviceId"), "device_type": GraphQLVariable("deviceType"), "device_make": GraphQLVariable("deviceMake"), "device_model": GraphQLVariable("deviceModel"), "device_version": GraphQLVariable("deviceVersion"), "id": GraphQLVariable("loginId"), "type": GraphQLVariable("type"), "phone": GraphQLVariable("phone"), "email": GraphQLVariable("email"), "password": GraphQLVariable("password")], type: .object(Login.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(login: Login? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "login": login.flatMap { (value: Login) -> ResultMap in value.resultMap }])
    }

    public var login: Login? {
      get {
        return (resultMap["login"] as? ResultMap).flatMap { Login(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "login")
      }
    }

    public struct Login: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Response"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("token", type: .scalar(String.self)),
          GraphQLField("refresh_token", type: .scalar(String.self)),
          GraphQLField("message", type: .scalar(String.self)),
          GraphQLField("status", type: .scalar(String.self)),
          GraphQLField("user", type: .object(User.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(token: String? = nil, refreshToken: String? = nil, message: String? = nil, status: String? = nil, user: User? = nil) {
        self.init(unsafeResultMap: ["__typename": "Response", "token": token, "refresh_token": refreshToken, "message": message, "status": status, "user": user.flatMap { (value: User) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
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

      public var user: User? {
        get {
          return (resultMap["user"] as? ResultMap).flatMap { User(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "user")
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
