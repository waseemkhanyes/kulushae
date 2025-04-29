// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension GQLK {
  class UpdatePasswordMutation: GraphQLMutation {
    static let operationName: String = "UpdatePassword"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation UpdatePassword($password: String!) { updatePassword(password: $password) { __typename message status } }"#
      ))

    public var password: String

    public init(password: String) {
      self.password = password
    }

    public var __variables: Variables? { ["password": password] }

    struct Data: GQLK.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("updatePassword", UpdatePassword?.self, arguments: ["password": .variable("password")]),
      ] }

      var updatePassword: UpdatePassword? { __data["updatePassword"] }

      /// UpdatePassword
      ///
      /// Parent Type: `Response`
      struct UpdatePassword: GQLK.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Response }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("message", String?.self),
          .field("status", String?.self),
        ] }

        var message: String? { __data["message"] }
        var status: String? { __data["status"] }
      }
    }
  }

}