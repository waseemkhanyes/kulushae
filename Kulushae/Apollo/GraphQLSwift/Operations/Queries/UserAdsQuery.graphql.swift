// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension GQLK {
  class UserAdsQuery: GraphQLQuery {
    static let operationName: String = "UserAds"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query UserAds($userId: Int, $page: Int) { userAds(user_id: $userId, page: $page) { __typename current_page per_page total data { __typename id image title type user_id } } }"#
      ))

    public var userId: GraphQLNullable<Int>
    public var page: GraphQLNullable<Int>

    public init(
      userId: GraphQLNullable<Int>,
      page: GraphQLNullable<Int>
    ) {
      self.userId = userId
      self.page = page
    }

    public var __variables: Variables? { [
      "userId": userId,
      "page": page
    ] }

    struct Data: GQLK.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("userAds", UserAds?.self, arguments: [
          "user_id": .variable("userId"),
          "page": .variable("page")
        ]),
      ] }

      var userAds: UserAds? { __data["userAds"] }

      /// UserAds
      ///
      /// Parent Type: `UserAds`
      struct UserAds: GQLK.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.UserAds }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("current_page", String?.self),
          .field("per_page", String?.self),
          .field("total", String?.self),
          .field("data", [Datum?].self),
        ] }

        var current_page: String? { __data["current_page"] }
        var per_page: String? { __data["per_page"] }
        var total: String? { __data["total"] }
        var data: [Datum?] { __data["data"] }

        /// UserAds.Datum
        ///
        /// Parent Type: `Ads`
        struct Datum: GQLK.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Ads }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", Int?.self),
            .field("image", String?.self),
            .field("title", String?.self),
            .field("type", String?.self),
            .field("user_id", Int?.self),
          ] }

          var id: Int? { __data["id"] }
          var image: String? { __data["image"] }
          var title: String? { __data["title"] }
          var type: String? { __data["type"] }
          var user_id: Int? { __data["user_id"] }
        }
      }
    }
  }

}