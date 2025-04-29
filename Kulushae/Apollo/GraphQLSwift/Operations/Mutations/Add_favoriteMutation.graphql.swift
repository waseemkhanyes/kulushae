// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension GQLK {
  class Add_favoriteMutation: GraphQLMutation {
    static let operationName: String = "Add_favorite"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation Add_favorite($like: Boolean!, $itemId: Int, $type: String) { add_favorite(like: $like, item_id: $itemId, type: $type) }"#
      ))

    public var like: Bool
    public var itemId: GraphQLNullable<Int>
    public var type: GraphQLNullable<String>

    public init(
      like: Bool,
      itemId: GraphQLNullable<Int>,
      type: GraphQLNullable<String>
    ) {
      self.like = like
      self.itemId = itemId
      self.type = type
    }

    public var __variables: Variables? { [
      "like": like,
      "itemId": itemId,
      "type": type
    ] }

    struct Data: GQLK.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("add_favorite", Bool.self, arguments: [
          "like": .variable("like"),
          "item_id": .variable("itemId"),
          "type": .variable("type")
        ]),
      ] }

      var add_favorite: Bool { __data["add_favorite"] }
    }
  }

}