// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension GQLK {
  class GetMessagesQuery: GraphQLQuery {
    static let operationName: String = "GetMessages"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query GetMessages($chatId: Int, $senderId: Int, $receiverId: Int, $categoryId: Int, $itemId: Int) { getMessages( chat_id: $chatId sender_id: $senderId receiver_id: $receiverId category_id: $categoryId item_id: $itemId ) { __typename chat_id createdAt id message receiver_id sender_id type } }"#
      ))

    public var chatId: GraphQLNullable<Int>
    public var senderId: GraphQLNullable<Int>
    public var receiverId: GraphQLNullable<Int>
    public var categoryId: GraphQLNullable<Int>
    public var itemId: GraphQLNullable<Int>

    public init(
      chatId: GraphQLNullable<Int>,
      senderId: GraphQLNullable<Int>,
      receiverId: GraphQLNullable<Int>,
      categoryId: GraphQLNullable<Int>,
      itemId: GraphQLNullable<Int>
    ) {
      self.chatId = chatId
      self.senderId = senderId
      self.receiverId = receiverId
      self.categoryId = categoryId
      self.itemId = itemId
    }

    public var __variables: Variables? { [
      "chatId": chatId,
      "senderId": senderId,
      "receiverId": receiverId,
      "categoryId": categoryId,
      "itemId": itemId
    ] }

    struct Data: GQLK.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("getMessages", [GetMessage?]?.self, arguments: [
          "chat_id": .variable("chatId"),
          "sender_id": .variable("senderId"),
          "receiver_id": .variable("receiverId"),
          "category_id": .variable("categoryId"),
          "item_id": .variable("itemId")
        ]),
      ] }

      var getMessages: [GetMessage?]? { __data["getMessages"] }

      /// GetMessage
      ///
      /// Parent Type: `Message`
      struct GetMessage: GQLK.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Message }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("chat_id", Int?.self),
          .field("createdAt", String?.self),
          .field("id", GQLK.ID?.self),
          .field("message", String?.self),
          .field("receiver_id", Int?.self),
          .field("sender_id", Int?.self),
          .field("type", String?.self),
        ] }

        var chat_id: Int? { __data["chat_id"] }
        var createdAt: String? { __data["createdAt"] }
        var id: GQLK.ID? { __data["id"] }
        var message: String? { __data["message"] }
        var receiver_id: Int? { __data["receiver_id"] }
        var sender_id: Int? { __data["sender_id"] }
        var type: String? { __data["type"] }
      }
    }
  }

}