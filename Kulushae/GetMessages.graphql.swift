// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class GetMessagesQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GetMessages($chatId: Int, $senderId: Int, $receiverId: Int, $categoryId: Int, $itemId: Int) {
      getMessages(chat_id: $chatId, sender_id: $senderId, receiver_id: $receiverId, category_id: $categoryId, item_id: $itemId) {
        __typename
        chat_id
        createdAt
        id
        message
        receiver_id
        sender_id
        type
      }
    }
    """

  public let operationName: String = "GetMessages"

  public var chatId: Int?
  public var senderId: Int?
  public var receiverId: Int?
  public var categoryId: Int?
  public var itemId: Int?

  public init(chatId: Int? = nil, senderId: Int? = nil, receiverId: Int? = nil, categoryId: Int? = nil, itemId: Int? = nil) {
    self.chatId = chatId
    self.senderId = senderId
    self.receiverId = receiverId
    self.categoryId = categoryId
    self.itemId = itemId
  }

  public var variables: GraphQLMap? {
    return ["chatId": chatId, "senderId": senderId, "receiverId": receiverId, "categoryId": categoryId, "itemId": itemId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getMessages", arguments: ["chat_id": GraphQLVariable("chatId"), "sender_id": GraphQLVariable("senderId"), "receiver_id": GraphQLVariable("receiverId"), "category_id": GraphQLVariable("categoryId"), "item_id": GraphQLVariable("itemId")], type: .list(.object(GetMessage.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getMessages: [GetMessage?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "getMessages": getMessages.flatMap { (value: [GetMessage?]) -> [ResultMap?] in value.map { (value: GetMessage?) -> ResultMap? in value.flatMap { (value: GetMessage) -> ResultMap in value.resultMap } } }])
    }

    public var getMessages: [GetMessage?]? {
      get {
        return (resultMap["getMessages"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [GetMessage?] in value.map { (value: ResultMap?) -> GetMessage? in value.flatMap { (value: ResultMap) -> GetMessage in GetMessage(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [GetMessage?]) -> [ResultMap?] in value.map { (value: GetMessage?) -> ResultMap? in value.flatMap { (value: GetMessage) -> ResultMap in value.resultMap } } }, forKey: "getMessages")
      }
    }

    public struct GetMessage: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Message"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("chat_id", type: .scalar(Int.self)),
          GraphQLField("createdAt", type: .scalar(String.self)),
          GraphQLField("id", type: .scalar(GraphQLID.self)),
          GraphQLField("message", type: .scalar(String.self)),
          GraphQLField("receiver_id", type: .scalar(Int.self)),
          GraphQLField("sender_id", type: .scalar(Int.self)),
          GraphQLField("type", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(chatId: Int? = nil, createdAt: String? = nil, id: GraphQLID? = nil, message: String? = nil, receiverId: Int? = nil, senderId: Int? = nil, type: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Message", "chat_id": chatId, "createdAt": createdAt, "id": id, "message": message, "receiver_id": receiverId, "sender_id": senderId, "type": type])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var chatId: Int? {
        get {
          return resultMap["chat_id"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "chat_id")
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

      public var id: GraphQLID? {
        get {
          return resultMap["id"] as? GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
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

      public var type: String? {
        get {
          return resultMap["type"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "type")
        }
      }
    }
  }
}
