// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension GQLK {
  class Motor_extrasQuery: GraphQLQuery {
    static let operationName: String = "Motor_extras"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query Motor_extras { motor_extras { __typename id title } }"#
      ))

    public init() {}

    struct Data: GQLK.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("motor_extras", [Motor_extra?]?.self),
      ] }

      var motor_extras: [Motor_extra?]? { __data["motor_extras"] }

      /// Motor_extra
      ///
      /// Parent Type: `Extra`
      struct Motor_extra: GQLK.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Extra }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", GQLK.ID?.self),
          .field("title", String?.self),
        ] }

        var id: GQLK.ID? { __data["id"] }
        var title: String? { __data["title"] }
      }
    }
  }

}