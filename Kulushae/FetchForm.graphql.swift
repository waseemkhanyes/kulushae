// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class FetchFormQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query FetchForm($categoryId: Int!, $steps: Int) {
      fetchForm(category_id: $categoryId, steps: $steps) {
        __typename
        field_extras
        field_id
        field_name
        field_order
        field_request_type
        field_size
        field_type
        field_validation
        id
        steps
        category_id
      }
    }
    """

  public let operationName: String = "FetchForm"

  public var categoryId: Int
  public var steps: Int?

  public init(categoryId: Int, steps: Int? = nil) {
    self.categoryId = categoryId
    self.steps = steps
  }

  public var variables: GraphQLMap? {
    return ["categoryId": categoryId, "steps": steps]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("fetchForm", arguments: ["category_id": GraphQLVariable("categoryId"), "steps": GraphQLVariable("steps")], type: .list(.list(.object(FetchForm.selections)))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(fetchForm: [[FetchForm?]?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "fetchForm": fetchForm.flatMap { (value: [[FetchForm?]?]) -> [[ResultMap?]?] in value.map { (value: [FetchForm?]?) -> [ResultMap?]? in value.flatMap { (value: [FetchForm?]) -> [ResultMap?] in value.map { (value: FetchForm?) -> ResultMap? in value.flatMap { (value: FetchForm) -> ResultMap in value.resultMap } } } } }])
    }

    public var fetchForm: [[FetchForm?]?]? {
      get {
        return (resultMap["fetchForm"] as? [[ResultMap?]?]).flatMap { (value: [[ResultMap?]?]) -> [[FetchForm?]?] in value.map { (value: [ResultMap?]?) -> [FetchForm?]? in value.flatMap { (value: [ResultMap?]) -> [FetchForm?] in value.map { (value: ResultMap?) -> FetchForm? in value.flatMap { (value: ResultMap) -> FetchForm in FetchForm(unsafeResultMap: value) } } } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [[FetchForm?]?]) -> [[ResultMap?]?] in value.map { (value: [FetchForm?]?) -> [ResultMap?]? in value.flatMap { (value: [FetchForm?]) -> [ResultMap?] in value.map { (value: FetchForm?) -> ResultMap? in value.flatMap { (value: FetchForm) -> ResultMap in value.resultMap } } } } }, forKey: "fetchForm")
      }
    }

    public struct FetchForm: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Form"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("field_extras", type: .scalar(String.self)),
          GraphQLField("field_id", type: .scalar(String.self)),
          GraphQLField("field_name", type: .scalar(String.self)),
          GraphQLField("field_order", type: .scalar(Int.self)),
          GraphQLField("field_request_type", type: .scalar(String.self)),
          GraphQLField("field_size", type: .scalar(Int.self)),
          GraphQLField("field_type", type: .scalar(String.self)),
          GraphQLField("field_validation", type: .scalar(String.self)),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("steps", type: .scalar(Int.self)),
          GraphQLField("category_id", type: .scalar(Int.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(fieldExtras: String? = nil, fieldId: String? = nil, fieldName: String? = nil, fieldOrder: Int? = nil, fieldRequestType: String? = nil, fieldSize: Int? = nil, fieldType: String? = nil, fieldValidation: String? = nil, id: GraphQLID, steps: Int? = nil, categoryId: Int? = nil) {
        self.init(unsafeResultMap: ["__typename": "Form", "field_extras": fieldExtras, "field_id": fieldId, "field_name": fieldName, "field_order": fieldOrder, "field_request_type": fieldRequestType, "field_size": fieldSize, "field_type": fieldType, "field_validation": fieldValidation, "id": id, "steps": steps, "category_id": categoryId])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fieldExtras: String? {
        get {
          return resultMap["field_extras"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "field_extras")
        }
      }

      public var fieldId: String? {
        get {
          return resultMap["field_id"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "field_id")
        }
      }

      public var fieldName: String? {
        get {
          return resultMap["field_name"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "field_name")
        }
      }

      public var fieldOrder: Int? {
        get {
          return resultMap["field_order"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "field_order")
        }
      }

      public var fieldRequestType: String? {
        get {
          return resultMap["field_request_type"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "field_request_type")
        }
      }

      public var fieldSize: Int? {
        get {
          return resultMap["field_size"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "field_size")
        }
      }

      public var fieldType: String? {
        get {
          return resultMap["field_type"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "field_type")
        }
      }

      public var fieldValidation: String? {
        get {
          return resultMap["field_validation"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "field_validation")
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

      public var steps: Int? {
        get {
          return resultMap["steps"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "steps")
        }
      }

      public var categoryId: Int? {
        get {
          return resultMap["category_id"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "category_id")
        }
      }
    }
  }
}
