// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension GQLK {
  class GetChatsQuery: GraphQLQuery {
    static let operationName: String = "GetChats"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query GetChats { getChats { __typename id receiver_id sender_id category_id type item_id item { __typename id title price image } receiver { __typename id image first_name last_name email phone is_premium createdAt } sender { __typename id image first_name last_name email phone is_premium createdAt } createdAt } }"#
      ))

    public init() {}

    struct Data: GQLK.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("getChats", [GetChat?]?.self),
      ] }

      var getChats: [GetChat?]? { __data["getChats"] }

      /// GetChat
      ///
      /// Parent Type: `Chat`
      struct GetChat: GQLK.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Chat }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", GQLK.ID?.self),
          .field("receiver_id", Int?.self),
          .field("sender_id", Int?.self),
          .field("category_id", Int?.self),
          .field("type", String?.self),
          .field("item_id", Int?.self),
          .field("item", Item?.self),
          .field("receiver", Receiver?.self),
          .field("sender", Sender?.self),
          .field("createdAt", String?.self),
        ] }

        var id: GQLK.ID? { __data["id"] }
        var receiver_id: Int? { __data["receiver_id"] }
        var sender_id: Int? { __data["sender_id"] }
        var category_id: Int? { __data["category_id"] }
        var type: String? { __data["type"] }
        var item_id: Int? { __data["item_id"] }
        var item: Item? { __data["item"] }
        var receiver: Receiver? { __data["receiver"] }
        var sender: Sender? { __data["sender"] }
        var createdAt: String? { __data["createdAt"] }

        /// GetChat.Item
        ///
        /// Parent Type: `Item`
        struct Item: GQLK.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Item }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", Int?.self),
            .field("title", String?.self),
            .field("price", Double?.self),
            .field("image", String?.self),
          ] }

          var id: Int? { __data["id"] }
          var title: String? { __data["title"] }
          var price: Double? { __data["price"] }
          var image: String? { __data["image"] }
        }

        /// GetChat.Receiver
        ///
        /// Parent Type: `User`
        struct Receiver: GQLK.SelectionSet {
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
            .field("is_premium", Bool?.self),
            .field("createdAt", String?.self),
          ] }

          var id: GQLK.ID? { __data["id"] }
          var image: String? { __data["image"] }
          var first_name: String? { __data["first_name"] }
          var last_name: String? { __data["last_name"] }
          var email: String? { __data["email"] }
          var phone: String? { __data["phone"] }
          var is_premium: Bool? { __data["is_premium"] }
          var createdAt: String? { __data["createdAt"] }
        }

        /// GetChat.Sender
        ///
        /// Parent Type: `User`
        struct Sender: GQLK.SelectionSet {
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
            .field("is_premium", Bool?.self),
            .field("createdAt", String?.self),
          ] }

          var id: GQLK.ID? { __data["id"] }
          var image: String? { __data["image"] }
          var first_name: String? { __data["first_name"] }
          var last_name: String? { __data["last_name"] }
          var email: String? { __data["email"] }
          var phone: String? { __data["phone"] }
          var is_premium: Bool? { __data["is_premium"] }
          var createdAt: String? { __data["createdAt"] }
        }
      }
    }
  }

}