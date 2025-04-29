// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension GQLK {
  class CategoriesQuery: GraphQLQuery {
    static let operationName: String = "Categories"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query Categories($showOnScreen: Int, $afl: Int, $categoryId: Int) { categories(show_on_screen: $showOnScreen, afl: $afl, category_id: $categoryId) { __typename has_child active_for_listing id image parent_id show_on_screen title has_form days price service_type bgColor } }"#
      ))

    public var showOnScreen: GraphQLNullable<Int>
    public var afl: GraphQLNullable<Int>
    public var categoryId: GraphQLNullable<Int>

    public init(
      showOnScreen: GraphQLNullable<Int>,
      afl: GraphQLNullable<Int>,
      categoryId: GraphQLNullable<Int>
    ) {
      self.showOnScreen = showOnScreen
      self.afl = afl
      self.categoryId = categoryId
    }

    public var __variables: Variables? { [
      "showOnScreen": showOnScreen,
      "afl": afl,
      "categoryId": categoryId
    ] }

    struct Data: GQLK.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("categories", [Category?].self, arguments: [
          "show_on_screen": .variable("showOnScreen"),
          "afl": .variable("afl"),
          "category_id": .variable("categoryId")
        ]),
      ] }

      var categories: [Category?] { __data["categories"] }

      /// Category
      ///
      /// Parent Type: `Category`
      struct Category: GQLK.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Category }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("has_child", Bool?.self),
          .field("active_for_listing", Bool?.self),
          .field("id", GQLK.ID.self),
          .field("image", String?.self),
          .field("parent_id", Int?.self),
          .field("show_on_screen", Int?.self),
          .field("title", String.self),
          .field("has_form", Bool?.self),
          .field("days", Int?.self),
          .field("price", Int?.self),
          .field("service_type", String?.self),
          .field("bgColor", String?.self),
        ] }

        var has_child: Bool? { __data["has_child"] }
        var active_for_listing: Bool? { __data["active_for_listing"] }
        var id: GQLK.ID { __data["id"] }
        var image: String? { __data["image"] }
        var parent_id: Int? { __data["parent_id"] }
        var show_on_screen: Int? { __data["show_on_screen"] }
        var title: String { __data["title"] }
        var has_form: Bool? { __data["has_form"] }
        var days: Int? { __data["days"] }
        var price: Int? { __data["price"] }
        var service_type: String? { __data["service_type"] }
        var bgColor: String? { __data["bgColor"] }
      }
    }
  }

}