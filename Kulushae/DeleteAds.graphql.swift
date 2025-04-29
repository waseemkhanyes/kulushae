// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class DeleteAdsMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation DeleteAds($ids: [DeleteItem]) {
      delete_item(ids: $ids)
    }
    """

  public let operationName: String = "DeleteAds"

  public var ids: [DeleteItem?]?

  public init(ids: [DeleteItem?]? = nil) {
    self.ids = ids
  }

  public var variables: GraphQLMap? {
    return ["ids": ids]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("delete_item", arguments: ["ids": GraphQLVariable("ids")], type: .scalar(Bool.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(deleteItem: Bool? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "delete_item": deleteItem])
    }

    public var deleteItem: Bool? {
      get {
        return resultMap["delete_item"] as? Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "delete_item")
      }
    }
  }
}
