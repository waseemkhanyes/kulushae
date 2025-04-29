// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class AddFavoriteMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation Add_favorite($like: Boolean!, $itemId: Int, $type: String) {
      add_favorite(like: $like, item_id: $itemId, type: $type)
    }
    """

  public let operationName: String = "Add_favorite"

  public var like: Bool
  public var itemId: Int?
  public var type: String?

  public init(like: Bool, itemId: Int? = nil, type: String? = nil) {
    self.like = like
    self.itemId = itemId
    self.type = type
  }

  public var variables: GraphQLMap? {
    return ["like": like, "itemId": itemId, "type": type]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("add_favorite", arguments: ["like": GraphQLVariable("like"), "item_id": GraphQLVariable("itemId"), "type": GraphQLVariable("type")], type: .nonNull(.scalar(Bool.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(addFavorite: Bool) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "add_favorite": addFavorite])
    }

    public var addFavorite: Bool {
      get {
        return resultMap["add_favorite"]! as! Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "add_favorite")
      }
    }
  }
}
