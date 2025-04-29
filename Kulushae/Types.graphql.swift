// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public struct DeleteItem: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - id
  ///   - type
  public init(id: Swift.Optional<Int?> = nil, type: Swift.Optional<String?> = nil) {
    graphQLMap = ["id": id, "type": type]
  }

  public var id: Swift.Optional<Int?> {
    get {
      return graphQLMap["id"] as? Swift.Optional<Int?> ?? Swift.Optional<Int?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "id")
    }
  }

  public var type: Swift.Optional<String?> {
    get {
      return graphQLMap["type"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }
}
