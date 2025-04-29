// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension GQLK {
  class Update_propertyMutation: GraphQLMutation {
    static let operationName: String = "Update_property"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation Update_property($itemId: Int, $args: JSON) { update_property(item_id: $itemId, args: $args) { __typename status message } }"#
      ))

    public var itemId: GraphQLNullable<Int>
    public var args: GraphQLNullable<JSON>

    public init(
      itemId: GraphQLNullable<Int>,
      args: GraphQLNullable<JSON>
    ) {
      self.itemId = itemId
      self.args = args
    }

    public var __variables: Variables? { [
      "itemId": itemId,
      "args": args
    ] }

    struct Data: GQLK.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("update_property", Update_property?.self, arguments: [
          "item_id": .variable("itemId"),
          "args": .variable("args")
        ]),
      ] }

      var update_property: Update_property? { __data["update_property"] }

      /// Update_property
      ///
      /// Parent Type: `UpdateResponse`
      struct Update_property: GQLK.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.UpdateResponse }
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