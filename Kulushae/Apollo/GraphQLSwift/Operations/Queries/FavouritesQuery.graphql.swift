// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension GQLK {
  class FavouritesQuery: GraphQLQuery {
    static let operationName: String = "Favourites"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query Favourites($userId: Int, $page: Int) { favourites(user_id: $userId, page: $page) { __typename current_page per_page total data { __typename id image size location title type user_id bathrooms bedrooms price car_year car_steering car_specs car_kilometers } } }"#
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
        .field("favourites", Favourites?.self, arguments: [
          "user_id": .variable("userId"),
          "page": .variable("page")
        ]),
      ] }

      var favourites: Favourites? { __data["favourites"] }

      /// Favourites
      ///
      /// Parent Type: `UserFavourites`
      struct Favourites: GQLK.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.UserFavourites }
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

        /// Favourites.Datum
        ///
        /// Parent Type: `Favourite`
        struct Datum: GQLK.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Favourite }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", Int?.self),
            .field("image", String?.self),
            .field("size", String?.self),
            .field("location", String?.self),
            .field("title", String?.self),
            .field("type", String?.self),
            .field("user_id", Int?.self),
            .field("bathrooms", String?.self),
            .field("bedrooms", String?.self),
            .field("price", String?.self),
            .field("car_year", String?.self),
            .field("car_steering", String?.self),
            .field("car_specs", String?.self),
            .field("car_kilometers", String?.self),
          ] }

          var id: Int? { __data["id"] }
          var image: String? { __data["image"] }
          var size: String? { __data["size"] }
          var location: String? { __data["location"] }
          var title: String? { __data["title"] }
          var type: String? { __data["type"] }
          var user_id: Int? { __data["user_id"] }
          var bathrooms: String? { __data["bathrooms"] }
          var bedrooms: String? { __data["bedrooms"] }
          var price: String? { __data["price"] }
          var car_year: String? { __data["car_year"] }
          var car_steering: String? { __data["car_steering"] }
          var car_specs: String? { __data["car_specs"] }
          var car_kilometers: String? { __data["car_kilometers"] }
        }
      }
    }
  }

}