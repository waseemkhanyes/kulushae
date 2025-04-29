// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class GetChatsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GetChats {
      getChats {
        __typename
        id
        receiver_id
        sender_id
        category_id
        type
        item_id
        item {
          __typename
          id
          title
          price
          image
        }
        receiver {
          __typename
          id
          image
          first_name
          last_name
          email
          phone
          is_premium
          createdAt
        }
        sender {
          __typename
          id
          image
          first_name
          last_name
          email
          phone
          is_premium
          createdAt
        }
        createdAt
      }
    }
    """

  public let operationName: String = "GetChats"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getChats", type: .list(.object(GetChat.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getChats: [GetChat?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "getChats": getChats.flatMap { (value: [GetChat?]) -> [ResultMap?] in value.map { (value: GetChat?) -> ResultMap? in value.flatMap { (value: GetChat) -> ResultMap in value.resultMap } } }])
    }

    public var getChats: [GetChat?]? {
      get {
        return (resultMap["getChats"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [GetChat?] in value.map { (value: ResultMap?) -> GetChat? in value.flatMap { (value: ResultMap) -> GetChat in GetChat(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [GetChat?]) -> [ResultMap?] in value.map { (value: GetChat?) -> ResultMap? in value.flatMap { (value: GetChat) -> ResultMap in value.resultMap } } }, forKey: "getChats")
      }
    }

    public struct GetChat: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Chat"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .scalar(GraphQLID.self)),
          GraphQLField("receiver_id", type: .scalar(Int.self)),
          GraphQLField("sender_id", type: .scalar(Int.self)),
          GraphQLField("category_id", type: .scalar(Int.self)),
          GraphQLField("type", type: .scalar(String.self)),
          GraphQLField("item_id", type: .scalar(Int.self)),
          GraphQLField("item", type: .object(Item.selections)),
          GraphQLField("receiver", type: .object(Receiver.selections)),
          GraphQLField("sender", type: .object(Sender.selections)),
          GraphQLField("createdAt", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID? = nil, receiverId: Int? = nil, senderId: Int? = nil, categoryId: Int? = nil, type: String? = nil, itemId: Int? = nil, item: Item? = nil, receiver: Receiver? = nil, sender: Sender? = nil, createdAt: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Chat", "id": id, "receiver_id": receiverId, "sender_id": senderId, "category_id": categoryId, "type": type, "item_id": itemId, "item": item.flatMap { (value: Item) -> ResultMap in value.resultMap }, "receiver": receiver.flatMap { (value: Receiver) -> ResultMap in value.resultMap }, "sender": sender.flatMap { (value: Sender) -> ResultMap in value.resultMap }, "createdAt": createdAt])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID? {
        get {
          return resultMap["id"] as? GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var receiverId: Int? {
        get {
          return resultMap["receiver_id"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "receiver_id")
        }
      }

      public var senderId: Int? {
        get {
          return resultMap["sender_id"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "sender_id")
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

      public var type: String? {
        get {
          return resultMap["type"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "type")
        }
      }

      public var itemId: Int? {
        get {
          return resultMap["item_id"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "item_id")
        }
      }

      public var item: Item? {
        get {
          return (resultMap["item"] as? ResultMap).flatMap { Item(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "item")
        }
      }

      public var receiver: Receiver? {
        get {
          return (resultMap["receiver"] as? ResultMap).flatMap { Receiver(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "receiver")
        }
      }

      public var sender: Sender? {
        get {
          return (resultMap["sender"] as? ResultMap).flatMap { Sender(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "sender")
        }
      }

      public var createdAt: String? {
        get {
          return resultMap["createdAt"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "createdAt")
        }
      }

      public struct Item: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Item"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .scalar(Int.self)),
            GraphQLField("title", type: .scalar(String.self)),
            GraphQLField("price", type: .scalar(Double.self)),
            GraphQLField("image", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: Int? = nil, title: String? = nil, price: Double? = nil, image: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "Item", "id": id, "title": title, "price": price, "image": image])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: Int? {
          get {
            return resultMap["id"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var title: String? {
          get {
            return resultMap["title"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "title")
          }
        }

        public var price: Double? {
          get {
            return resultMap["price"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "price")
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
      }

      public struct Receiver: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["User"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .scalar(GraphQLID.self)),
            GraphQLField("image", type: .scalar(String.self)),
            GraphQLField("first_name", type: .scalar(String.self)),
            GraphQLField("last_name", type: .scalar(String.self)),
            GraphQLField("email", type: .scalar(String.self)),
            GraphQLField("phone", type: .scalar(String.self)),
            GraphQLField("is_premium", type: .scalar(Bool.self)),
            GraphQLField("createdAt", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID? = nil, image: String? = nil, firstName: String? = nil, lastName: String? = nil, email: String? = nil, phone: String? = nil, isPremium: Bool? = nil, createdAt: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "User", "id": id, "image": image, "first_name": firstName, "last_name": lastName, "email": email, "phone": phone, "is_premium": isPremium, "createdAt": createdAt])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID? {
          get {
            return resultMap["id"] as? GraphQLID
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

        public var firstName: String? {
          get {
            return resultMap["first_name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "first_name")
          }
        }

        public var lastName: String? {
          get {
            return resultMap["last_name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "last_name")
          }
        }

        public var email: String? {
          get {
            return resultMap["email"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "email")
          }
        }

        public var phone: String? {
          get {
            return resultMap["phone"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "phone")
          }
        }

        public var isPremium: Bool? {
          get {
            return resultMap["is_premium"] as? Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "is_premium")
          }
        }

        public var createdAt: String? {
          get {
            return resultMap["createdAt"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "createdAt")
          }
        }
      }

      public struct Sender: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["User"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .scalar(GraphQLID.self)),
            GraphQLField("image", type: .scalar(String.self)),
            GraphQLField("first_name", type: .scalar(String.self)),
            GraphQLField("last_name", type: .scalar(String.self)),
            GraphQLField("email", type: .scalar(String.self)),
            GraphQLField("phone", type: .scalar(String.self)),
            GraphQLField("is_premium", type: .scalar(Bool.self)),
            GraphQLField("createdAt", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID? = nil, image: String? = nil, firstName: String? = nil, lastName: String? = nil, email: String? = nil, phone: String? = nil, isPremium: Bool? = nil, createdAt: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "User", "id": id, "image": image, "first_name": firstName, "last_name": lastName, "email": email, "phone": phone, "is_premium": isPremium, "createdAt": createdAt])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID? {
          get {
            return resultMap["id"] as? GraphQLID
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

        public var firstName: String? {
          get {
            return resultMap["first_name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "first_name")
          }
        }

        public var lastName: String? {
          get {
            return resultMap["last_name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "last_name")
          }
        }

        public var email: String? {
          get {
            return resultMap["email"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "email")
          }
        }

        public var phone: String? {
          get {
            return resultMap["phone"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "phone")
          }
        }

        public var isPremium: Bool? {
          get {
            return resultMap["is_premium"] as? Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "is_premium")
          }
        }

        public var createdAt: String? {
          get {
            return resultMap["createdAt"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "createdAt")
          }
        }
      }
    }
  }
}
