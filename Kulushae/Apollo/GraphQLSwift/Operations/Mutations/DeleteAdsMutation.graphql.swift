// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension GQLK {
  class DeleteAdsMutation: GraphQLMutation {
    static let operationName: String = "DeleteAds"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation DeleteAds($ids: [DeleteItem]!) { delete_item(ids: $ids) }"#
      ))

    public var ids: [DeleteItem?]

    public init(ids: [DeleteItem?]) {
      self.ids = ids
    }

    public var __variables: Variables? { ["ids": ids] }

    struct Data: GQLK.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("delete_item", Bool?.self, arguments: ["ids": .variable("ids")]),
      ] }

      var delete_item: Bool? { __data["delete_item"] }
    }
  }

}