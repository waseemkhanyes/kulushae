// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension GQLK {
  class LoginMutation: GraphQLMutation {
    static let operationName: String = "Login"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation Login($fcmToken: String, $deviceId: String, $deviceType: String, $deviceMake: String, $deviceModel: String, $deviceVersion: String, $loginId: String, $type: String, $phone: String, $email: String, $password: String) { login( fcm_token: $fcmToken device_id: $deviceId device_type: $deviceType device_make: $deviceMake device_model: $deviceModel device_version: $deviceVersion id: $loginId type: $type phone: $phone email: $email password: $password ) { __typename token refresh_token message status user { __typename id image first_name last_name email phone is_premium createdAt } } }"#
      ))

    public var fcmToken: GraphQLNullable<String>
    public var deviceId: GraphQLNullable<String>
    public var deviceType: GraphQLNullable<String>
    public var deviceMake: GraphQLNullable<String>
    public var deviceModel: GraphQLNullable<String>
    public var deviceVersion: GraphQLNullable<String>
    public var loginId: GraphQLNullable<String>
    public var type: GraphQLNullable<String>
    public var phone: GraphQLNullable<String>
    public var email: GraphQLNullable<String>
    public var password: GraphQLNullable<String>

    public init(
      fcmToken: GraphQLNullable<String>,
      deviceId: GraphQLNullable<String>,
      deviceType: GraphQLNullable<String>,
      deviceMake: GraphQLNullable<String>,
      deviceModel: GraphQLNullable<String>,
      deviceVersion: GraphQLNullable<String>,
      loginId: GraphQLNullable<String>,
      type: GraphQLNullable<String>,
      phone: GraphQLNullable<String>,
      email: GraphQLNullable<String>,
      password: GraphQLNullable<String>
    ) {
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

    public var __variables: Variables? { [
      "fcmToken": fcmToken,
      "deviceId": deviceId,
      "deviceType": deviceType,
      "deviceMake": deviceMake,
      "deviceModel": deviceModel,
      "deviceVersion": deviceVersion,
      "loginId": loginId,
      "type": type,
      "phone": phone,
      "email": email,
      "password": password
    ] }

    struct Data: GQLK.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("login", Login?.self, arguments: [
          "fcm_token": .variable("fcmToken"),
          "device_id": .variable("deviceId"),
          "device_type": .variable("deviceType"),
          "device_make": .variable("deviceMake"),
          "device_model": .variable("deviceModel"),
          "device_version": .variable("deviceVersion"),
          "id": .variable("loginId"),
          "type": .variable("type"),
          "phone": .variable("phone"),
          "email": .variable("email"),
          "password": .variable("password")
        ]),
      ] }

      var login: Login? { __data["login"] }

      /// Login
      ///
      /// Parent Type: `Response`
      struct Login: GQLK.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Response }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("token", String?.self),
          .field("refresh_token", String?.self),
          .field("message", String?.self),
          .field("status", String?.self),
          .field("user", User?.self),
        ] }

        var token: String? { __data["token"] }
        var refresh_token: String? { __data["refresh_token"] }
        var message: String? { __data["message"] }
        var status: String? { __data["status"] }
        var user: User? { __data["user"] }

        /// Login.User
        ///
        /// Parent Type: `User`
        struct User: GQLK.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.User }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", GQLK.ID?.self),
            .field("image", String?.self),
            .field("first_name", String?.self),
            .field("last_name", String?.self),
            .field("email", String?.self),
            .field("phone", String?.self),
            .field("is_premium", Bool?.self),
            .field("createdAt", String?.self),
          ] }

          var id: GQLK.ID? { __data["id"] }
          var image: String? { __data["image"] }
          var first_name: String? { __data["first_name"] }
          var last_name: String? { __data["last_name"] }
          var email: String? { __data["email"] }
          var phone: String? { __data["phone"] }
          var is_premium: Bool? { __data["is_premium"] }
          var createdAt: String? { __data["createdAt"] }
        }
      }
    }
  }

}