// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension GQLK {
  class RegisterMutation: GraphQLMutation {
    static let operationName: String = "Register"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation Register($firstName: String, $lastName: String, $email: String, $phone: String, $type: String, $registerId: String, $deviceVersion: String, $deviceModel: String, $deviceMake: String, $deviceType: String, $deviceId: String, $fcmToken: String, $password: String) { register( first_name: $firstName last_name: $lastName email: $email phone: $phone type: $type id: $registerId device_version: $deviceVersion device_model: $deviceModel device_make: $deviceMake device_type: $deviceType device_id: $deviceId fcm_token: $fcmToken password: $password ) { __typename user { __typename id image first_name last_name email phone is_premium createdAt } token refresh_token message status } }"#
      ))

    public var firstName: GraphQLNullable<String>
    public var lastName: GraphQLNullable<String>
    public var email: GraphQLNullable<String>
    public var phone: GraphQLNullable<String>
    public var type: GraphQLNullable<String>
    public var registerId: GraphQLNullable<String>
    public var deviceVersion: GraphQLNullable<String>
    public var deviceModel: GraphQLNullable<String>
    public var deviceMake: GraphQLNullable<String>
    public var deviceType: GraphQLNullable<String>
    public var deviceId: GraphQLNullable<String>
    public var fcmToken: GraphQLNullable<String>
    public var password: GraphQLNullable<String>

    public init(
      firstName: GraphQLNullable<String>,
      lastName: GraphQLNullable<String>,
      email: GraphQLNullable<String>,
      phone: GraphQLNullable<String>,
      type: GraphQLNullable<String>,
      registerId: GraphQLNullable<String>,
      deviceVersion: GraphQLNullable<String>,
      deviceModel: GraphQLNullable<String>,
      deviceMake: GraphQLNullable<String>,
      deviceType: GraphQLNullable<String>,
      deviceId: GraphQLNullable<String>,
      fcmToken: GraphQLNullable<String>,
      password: GraphQLNullable<String>
    ) {
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

    public var __variables: Variables? { [
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "phone": phone,
      "type": type,
      "registerId": registerId,
      "deviceVersion": deviceVersion,
      "deviceModel": deviceModel,
      "deviceMake": deviceMake,
      "deviceType": deviceType,
      "deviceId": deviceId,
      "fcmToken": fcmToken,
      "password": password
    ] }

    struct Data: GQLK.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("register", Register?.self, arguments: [
          "first_name": .variable("firstName"),
          "last_name": .variable("lastName"),
          "email": .variable("email"),
          "phone": .variable("phone"),
          "type": .variable("type"),
          "id": .variable("registerId"),
          "device_version": .variable("deviceVersion"),
          "device_model": .variable("deviceModel"),
          "device_make": .variable("deviceMake"),
          "device_type": .variable("deviceType"),
          "device_id": .variable("deviceId"),
          "fcm_token": .variable("fcmToken"),
          "password": .variable("password")
        ]),
      ] }

      var register: Register? { __data["register"] }

      /// Register
      ///
      /// Parent Type: `Response`
      struct Register: GQLK.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Response }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("user", User?.self),
          .field("token", String?.self),
          .field("refresh_token", String?.self),
          .field("message", String?.self),
          .field("status", String?.self),
        ] }

        var user: User? { __data["user"] }
        var token: String? { __data["token"] }
        var refresh_token: String? { __data["refresh_token"] }
        var message: String? { __data["message"] }
        var status: String? { __data["status"] }

        /// Register.User
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