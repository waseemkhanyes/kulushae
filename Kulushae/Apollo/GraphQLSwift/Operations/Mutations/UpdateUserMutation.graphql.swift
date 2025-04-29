// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension GQLK {
  class UpdateUserMutation: GraphQLMutation {
    static let operationName: String = "UpdateUser"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation UpdateUser($userId: Int, $values: JSON) { updateUser(user_id: $userId, values: $values) { __typename id image first_name last_name email phone createdAt } }"#
      ))

    public var userId: GraphQLNullable<Int>
    public var values: GraphQLNullable<JSON>

    public init(
      userId: GraphQLNullable<Int>,
      values: GraphQLNullable<JSON>
    ) {
      self.userId = userId
      self.values = values
    }

    public var __variables: Variables? { [
      "userId": userId,
      "values": values
    ] }

    struct Data: GQLK.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("updateUser", UpdateUser?.self, arguments: [
          "user_id": .variable("userId"),
          "values": .variable("values")
        ]),
      ] }

      var updateUser: UpdateUser? { __data["updateUser"] }

      /// UpdateUser
      ///
      /// Parent Type: `User`
      struct UpdateUser: GQLK.SelectionSet {
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
          .field("createdAt", String?.self),
        ] }

        var id: GQLK.ID? { __data["id"] }
        var image: String? { __data["image"] }
        var first_name: String? { __data["first_name"] }
        var last_name: String? { __data["last_name"] }
        var email: String? { __data["email"] }
        var phone: String? { __data["phone"] }
        var createdAt: String? { __data["createdAt"] }
      }
    }
  }

}