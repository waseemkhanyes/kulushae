// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension GQLK {
  class Store_propertyMutation: GraphQLMutation {
    static let operationName: String = "Store_property"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation Store_property($args: JSON) { store_property(args: $args) { __typename message status payment { __typename amount cart_description cart_id country_code currency_code } } }"#
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
        .field("store_property", Store_property?.self, arguments: ["args": .variable("args")]),
      ] }

      var store_property: Store_property? { __data["store_property"] }

      /// Store_property
      ///
      /// Parent Type: `MutationResponse`
      struct Store_property: GQLK.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.MutationResponse }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("message", String?.self),
          .field("status", String?.self),
          .field("payment", Payment?.self),
        ] }

        var message: String? { __data["message"] }
        var status: String? { __data["status"] }
        var payment: Payment? { __data["payment"] }

        /// Store_property.Payment
        ///
        /// Parent Type: `Payment`
        struct Payment: GQLK.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Payment }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("amount", String?.self),
            .field("cart_description", String?.self),
            .field("cart_id", String?.self),
            .field("country_code", String?.self),
            .field("currency_code", String?.self),
          ] }

          var amount: String? { __data["amount"] }
          var cart_description: String? { __data["cart_description"] }
          var cart_id: String? { __data["cart_id"] }
          var country_code: String? { __data["country_code"] }
          var currency_code: String? { __data["currency_code"] }
        }
      }
    }
  }

}