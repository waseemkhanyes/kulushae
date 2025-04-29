// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension GQLK {
  class UserVerficationMutation: GraphQLMutation {
    static let operationName: String = "UserVerfication"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation UserVerfication($value: String, $type: String) { userVerfication(value: $value, type: $type) { __typename isExist status token } }"#
      ))

    public var value: GraphQLNullable<String>
    public var type: GraphQLNullable<String>

    public init(
      value: GraphQLNullable<String>,
      type: GraphQLNullable<String>
    ) {
      self.value = value
      self.type = type
    }

    public var __variables: Variables? { [
      "value": value,
      "type": type
    ] }

    struct Data: GQLK.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("userVerfication", UserVerfication?.self, arguments: [
          "value": .variable("value"),
          "type": .variable("type")
        ]),
      ] }

      var userVerfication: UserVerfication? { __data["userVerfication"] }

      /// UserVerfication
      ///
      /// Parent Type: `UserVerficationResponse`
      struct UserVerfication: GQLK.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.UserVerficationResponse }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("isExist", Bool?.self),
          .field("status", String?.self),
          .field("token", String?.self),
        ] }

        var isExist: Bool? { __data["isExist"] }
        var status: String? { __data["status"] }
        var token: String? { __data["token"] }
      }
    }
  }

}