// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class StoreMotorsMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation Store_motors($args: JSON) {
      store_motors(args: $args) {
        __typename
        message
        payment {
          __typename
          currency_code
          country_code
          cart_description
          cart_id
          amount
        }
        status
      }
    }
    """

  public let operationName: String = "Store_motors"

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
        GraphQLField("store_motors", arguments: ["args": GraphQLVariable("args")], type: .object(StoreMotor.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(storeMotors: StoreMotor? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "store_motors": storeMotors.flatMap { (value: StoreMotor) -> ResultMap in value.resultMap }])
    }

    public var storeMotors: StoreMotor? {
      get {
        return (resultMap["store_motors"] as? ResultMap).flatMap { StoreMotor(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "store_motors")
      }
    }

    public struct StoreMotor: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["MutationResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("message", type: .scalar(String.self)),
          GraphQLField("payment", type: .object(Payment.selections)),
          GraphQLField("status", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(message: String? = nil, payment: Payment? = nil, status: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "MutationResponse", "message": message, "payment": payment.flatMap { (value: Payment) -> ResultMap in value.resultMap }, "status": status])
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

      public var payment: Payment? {
        get {
          return (resultMap["payment"] as? ResultMap).flatMap { Payment(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "payment")
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

      public struct Payment: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Payment"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("currency_code", type: .scalar(String.self)),
            GraphQLField("country_code", type: .scalar(String.self)),
            GraphQLField("cart_description", type: .scalar(String.self)),
            GraphQLField("cart_id", type: .scalar(String.self)),
            GraphQLField("amount", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(currencyCode: String? = nil, countryCode: String? = nil, cartDescription: String? = nil, cartId: String? = nil, amount: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "Payment", "currency_code": currencyCode, "country_code": countryCode, "cart_description": cartDescription, "cart_id": cartId, "amount": amount])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
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

        public var countryCode: String? {
          get {
            return resultMap["country_code"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "country_code")
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

        public var amount: String? {
          get {
            return resultMap["amount"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "amount")
          }
        }
      }
    }
  }
}
