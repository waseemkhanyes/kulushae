// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension GQLK {
  class Motor_makesQuery: GraphQLQuery {
    static let operationName: String = "Motor_makes"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query Motor_makes($page: Int, $value: String) { motor_makes(page: $page, value: $value) { __typename current_page per_page total data { __typename id image title } } }"#
      ))

    public var page: GraphQLNullable<Int>
    public var value: GraphQLNullable<String>

    public init(
      page: GraphQLNullable<Int>,
      value: GraphQLNullable<String>
    ) {
      self.page = page
      self.value = value
    }

    public var __variables: Variables? { [
      "page": page,
      "value": value
    ] }

    struct Data: GQLK.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("motor_makes", Motor_makes?.self, arguments: [
          "page": .variable("page"),
          "value": .variable("value")
        ]),
      ] }

      var motor_makes: Motor_makes? { __data["motor_makes"] }

      /// Motor_makes
      ///
      /// Parent Type: `MakesResponse`
      struct Motor_makes: GQLK.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.MakesResponse }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("current_page", String?.self),
          .field("per_page", String?.self),
          .field("total", String?.self),
          .field("data", [Datum?]?.self),
        ] }

        var current_page: String? { __data["current_page"] }
        var per_page: String? { __data["per_page"] }
        var total: String? { __data["total"] }
        var data: [Datum?]? { __data["data"] }

        /// Motor_makes.Datum
        ///
        /// Parent Type: `MotorMake`
        struct Datum: GQLK.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.MotorMake }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", GQLK.ID?.self),
            .field("image", String?.self),
            .field("title", String?.self),
          ] }

          var id: GQLK.ID? { __data["id"] }
          var image: String? { __data["image"] }
          var title: String? { __data["title"] }
        }
      }
    }
  }

}