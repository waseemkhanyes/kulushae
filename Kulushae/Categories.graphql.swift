// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class CategoriesQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Categories($showOnScreen: Int, $afl: Int, $categoryId: Int) {
      categories(show_on_screen: $showOnScreen, afl: $afl, category_id: $categoryId) {
        __typename
        has_child
        active_for_listing
        id
        image
        parent_id
        show_on_screen
        title
        has_form
        days
        price
        service_type
      }
    }
    """

  public let operationName: String = "Categories"

  public var showOnScreen: Int?
  public var afl: Int?
  public var categoryId: Int?

  public init(showOnScreen: Int? = nil, afl: Int? = nil, categoryId: Int? = nil) {
    self.showOnScreen = showOnScreen
    self.afl = afl
    self.categoryId = categoryId
  }

  public var variables: GraphQLMap? {
    return ["showOnScreen": showOnScreen, "afl": afl, "categoryId": categoryId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("categories", arguments: ["show_on_screen": GraphQLVariable("showOnScreen"), "afl": GraphQLVariable("afl"), "category_id": GraphQLVariable("categoryId")], type: .nonNull(.list(.object(Category.selections)))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(categories: [Category?]) {
      self.init(unsafeResultMap: ["__typename": "Query", "categories": categories.map { (value: Category?) -> ResultMap? in value.flatMap { (value: Category) -> ResultMap in value.resultMap } }])
    }

    public var categories: [Category?] {
      get {
        return (resultMap["categories"] as! [ResultMap?]).map { (value: ResultMap?) -> Category? in value.flatMap { (value: ResultMap) -> Category in Category(unsafeResultMap: value) } }
      }
      set {
        resultMap.updateValue(newValue.map { (value: Category?) -> ResultMap? in value.flatMap { (value: Category) -> ResultMap in value.resultMap } }, forKey: "categories")
      }
    }

    public struct Category: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Category"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("has_child", type: .scalar(Bool.self)),
          GraphQLField("active_for_listing", type: .scalar(Bool.self)),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("image", type: .scalar(String.self)),
          GraphQLField("parent_id", type: .scalar(Int.self)),
          GraphQLField("show_on_screen", type: .scalar(Int.self)),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("has_form", type: .scalar(Bool.self)),
          GraphQLField("days", type: .scalar(Int.self)),
          GraphQLField("price", type: .scalar(Int.self)),
          GraphQLField("service_type", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(hasChild: Bool? = nil, activeForListing: Bool? = nil, id: GraphQLID, image: String? = nil, parentId: Int? = nil, showOnScreen: Int? = nil, title: String, hasForm: Bool? = nil, days: Int? = nil, price: Int? = nil, serviceType: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Category", "has_child": hasChild, "active_for_listing": activeForListing, "id": id, "image": image, "parent_id": parentId, "show_on_screen": showOnScreen, "title": title, "has_form": hasForm, "days": days, "price": price, "service_type": serviceType])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var hasChild: Bool? {
        get {
          return resultMap["has_child"] as? Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "has_child")
        }
      }

      public var activeForListing: Bool? {
        get {
          return resultMap["active_for_listing"] as? Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "active_for_listing")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var image: String? {
        get {
          return resultMap["image"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "image")
        }
      }

      public var parentId: Int? {
        get {
          return resultMap["parent_id"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "parent_id")
        }
      }

      public var showOnScreen: Int? {
        get {
          return resultMap["show_on_screen"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "show_on_screen")
        }
      }

      public var title: String {
        get {
          return resultMap["title"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "title")
        }
      }

      public var hasForm: Bool? {
        get {
          return resultMap["has_form"] as? Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "has_form")
        }
      }

      public var days: Int? {
        get {
          return resultMap["days"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "days")
        }
      }

      public var price: Int? {
        get {
          return resultMap["price"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "price")
        }
      }

      public var serviceType: String? {
        get {
          return resultMap["service_type"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "service_type")
        }
      }
    }
  }
}
