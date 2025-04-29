// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension GQLK {
  class FetchFormQuery: GraphQLQuery {
    static let operationName: String = "FetchForm"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query FetchForm($categoryId: Int!, $steps: Int) { fetchForm(category_id: $categoryId, steps: $steps) { __typename field_extras field_id field_name field_order field_request_type field_size field_type field_validation id steps category_id } }"#
      ))

    public var categoryId: Int
    public var steps: GraphQLNullable<Int>

    public init(
      categoryId: Int,
      steps: GraphQLNullable<Int>
    ) {
      self.categoryId = categoryId
      self.steps = steps
    }

    public var __variables: Variables? { [
      "categoryId": categoryId,
      "steps": steps
    ] }

    struct Data: GQLK.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("fetchForm", [[FetchForm?]?]?.self, arguments: [
          "category_id": .variable("categoryId"),
          "steps": .variable("steps")
        ]),
      ] }

      var fetchForm: [[FetchForm?]?]? { __data["fetchForm"] }

      /// FetchForm
      ///
      /// Parent Type: `Form`
      struct FetchForm: GQLK.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Form }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("field_extras", String?.self),
          .field("field_id", String?.self),
          .field("field_name", String?.self),
          .field("field_order", Int?.self),
          .field("field_request_type", String?.self),
          .field("field_size", Int?.self),
          .field("field_type", String?.self),
          .field("field_validation", String?.self),
          .field("id", GQLK.ID.self),
          .field("steps", Int?.self),
          .field("category_id", Int?.self),
        ] }

        var field_extras: String? { __data["field_extras"] }
        var field_id: String? { __data["field_id"] }
        var field_name: String? { __data["field_name"] }
        var field_order: Int? { __data["field_order"] }
        var field_request_type: String? { __data["field_request_type"] }
        var field_size: Int? { __data["field_size"] }
        var field_type: String? { __data["field_type"] }
        var field_validation: String? { __data["field_validation"] }
        var id: GQLK.ID { __data["id"] }
        var steps: Int? { __data["steps"] }
        var category_id: Int? { __data["category_id"] }
      }
    }
  }

}