// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension GQLK {
  class DeleteUserMutation: GraphQLMutation {
    static let operationName: String = "DeleteUser"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation DeleteUser { deleteUser { __typename status message } }"#
      ))

    public init() {}

    struct Data: GQLK.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("deleteUser", DeleteUser?.self),
      ] }

      var deleteUser: DeleteUser? { __data["deleteUser"] }

      /// DeleteUser
      ///
      /// Parent Type: `Response`
      struct DeleteUser: GQLK.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Response }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("status", String?.self),
          .field("message", String?.self),
        ] }

        var status: String? { __data["status"] }
        var message: String? { __data["message"] }
      }
    }
  }

}