// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension GQLK {
  class SearchQuery: GraphQLQuery {
    static let operationName: String = "Search"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query Search($value: String!, $serviceType: String!) { search(value: $value, service_type: $serviceType) { __typename ads category category_id title type } }"#
      ))

    public var value: String
    public var serviceType: String

    public init(
      value: String,
      serviceType: String
    ) {
      self.value = value
      self.serviceType = serviceType
    }

    public var __variables: Variables? { [
      "value": value,
      "serviceType": serviceType
    ] }

    struct Data: GQLK.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("search", [Search?]?.self, arguments: [
          "value": .variable("value"),
          "service_type": .variable("serviceType")
        ]),
      ] }

      var search: [Search?]? { __data["search"] }

      /// Search
      ///
      /// Parent Type: `SearchResponse`
      struct Search: GQLK.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.SearchResponse }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("ads", Int?.self),
          .field("category", String?.self),
          .field("category_id", Int?.self),
          .field("title", String?.self),
          .field("type", String?.self),
        ] }

        var ads: Int? { __data["ads"] }
        var category: String? { __data["category"] }
        var category_id: Int? { __data["category_id"] }
        var title: String? { __data["title"] }
        var type: String? { __data["type"] }
      }
    }
  }

}