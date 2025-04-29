// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension GQLK {
  class UserInfoQuery: GraphQLQuery {
    static let operationName: String = "UserInfo"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query UserInfo($userInfoId: Int) { userInfo(id: $userInfoId) { __typename id image first_name last_name email phone createdAt } }"#
      ))

    public var userInfoId: GraphQLNullable<Int>

    public init(userInfoId: GraphQLNullable<Int>) {
      self.userInfoId = userInfoId
    }

    public var __variables: Variables? { ["userInfoId": userInfoId] }

    struct Data: GQLK.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("userInfo", UserInfo?.self, arguments: ["id": .variable("userInfoId")]),
      ] }

      var userInfo: UserInfo? { __data["userInfo"] }

      /// UserInfo
      ///
      /// Parent Type: `User`
      struct UserInfo: GQLK.SelectionSet {
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