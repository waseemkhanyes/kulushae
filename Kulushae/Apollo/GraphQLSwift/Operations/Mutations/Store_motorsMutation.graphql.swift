// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension GQLK {
  class Store_motorsMutation: GraphQLMutation {
    static let operationName: String = "Store_motors"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation Store_motors($args: JSON) { store_motors(args: $args) { __typename message payment { __typename currency_code country_code cart_description cart_id amount } status } }"#
      ))

    public var args: GraphQLNullable<JSON>

    public init(args: GraphQLNullable<JSON>) {
      self.args = args
    }

    public var __variables: Variables? { ["args": args] }

    struct Data: GQLK.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("store_motors", Store_motors?.self, arguments: ["args": .variable("args")]),
      ] }

      var store_motors: Store_motors? { __data["store_motors"] }

      /// Store_motors
      ///
      /// Parent Type: `MutationResponse`
      struct Store_motors: GQLK.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.MutationResponse }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("message", String?.self),
          .field("payment", Payment?.self),
          .field("status", String?.self),
        ] }

        var message: String? { __data["message"] }
        var payment: Payment? { __data["payment"] }
        var status: String? { __data["status"] }

        /// Store_motors.Payment
        ///
        /// Parent Type: `Payment`
        struct Payment: GQLK.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Payment }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("currency_code", String?.self),
            .field("country_code", String?.self),
            .field("cart_description", String?.self),
            .field("cart_id", String?.self),
            .field("amount", String?.self),
          ] }

          var currency_code: String? { __data["currency_code"] }
          var country_code: String? { __data["country_code"] }
          var cart_description: String? { __data["cart_description"] }
          var cart_id: String? { __data["cart_id"] }
          var amount: String? { __data["amount"] }
        }
      }
    }
  }

}