// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class StorePropertyMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation Store_property($args: JSON) {
      store_property(args: $args) {
        __typename
        message
        status
        payment {
          __typename
          amount
          cart_description
          cart_id
          country_code
          currency_code
        }
      }
    }
    """

  public let operationName: String = "Store_property"

  public var args: String?

  public init(args: String? = nil) {
    self.args = args
  }

  public var variables: GraphQLMap? {
    return ["args": args]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("store_property", arguments: ["args": GraphQLVariable("args")], type: .object(StoreProperty.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(storeProperty: StoreProperty? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "store_property": storeProperty.flatMap { (value: StoreProperty) -> ResultMap in value.resultMap }])
    }

    public var storeProperty: StoreProperty? {
      get {
        return (resultMap["store_property"] as? ResultMap).flatMap { StoreProperty(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "store_property")
      }
    }

    public struct StoreProperty: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MutationResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("message", type: .scalar(String.self)),
          GraphQLField("status", type: .scalar(String.self)),
          GraphQLField("payment", type: .object(Payment.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(message: String? = nil, status: String? = nil, payment: Payment? = nil) {
        self.init(unsafeResultMap: ["__typename": "MutationResponse", "message": message, "status": status, "payment": payment.flatMap { (value: Payment) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var message: String? {
        get {
          return resultMap["message"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "message")
        }
      }

      public var status: String? {
        get {
          return resultMap["status"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "status")
        }
      }

      public var payment: Payment? {
        get {
          return (resultMap["payment"] as? ResultMap).flatMap { Payment(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "payment")
        }
      }

      public struct Payment: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Payment"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("amount", type: .scalar(String.self)),
            GraphQLField("cart_description", type: .scalar(String.self)),
            GraphQLField("cart_id", type: .scalar(String.self)),
            GraphQLField("country_code", type: .scalar(String.self)),
            GraphQLField("currency_code", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(amount: String? = nil, cartDescription: String? = nil, cartId: String? = nil, countryCode: String? = nil, currencyCode: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "Payment", "amount": amount, "cart_description": cartDescription, "cart_id": cartId, "country_code": countryCode, "currency_code": currencyCode])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var amount: String? {
          get {
            return resultMap["amount"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "amount")
          }
        }

        public var cartDescription: String? {
          get {
            return resultMap["cart_description"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "cart_description")
          }
        }

        public var cartId: String? {
          get {
            return resultMap["cart_id"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "cart_id")
          }
        }

        public var countryCode: String? {
          get {
            return resultMap["country_code"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "country_code")
          }
        }

        public var currencyCode: String? {
          get {
            return resultMap["currency_code"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "currency_code")
          }
        }
      }
    }
  }
}
