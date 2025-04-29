// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension GQLK {
  struct DeleteItem: InputObject {
    private(set) var __data: InputDict

    init(_ data: InputDict) {
      __data = data
    }

    init(
      id: GraphQLNullable<Int> = nil,
      type: GraphQLNullable<String> = nil
    ) {
      __data = InputDict([
        "id": id,
        "type": type
      ])
    }

    var id: GraphQLNullable<Int> {
      get { __data["id"] }
      set { __data["id"] = newValue }
    }

    var type: GraphQLNullable<String> {
      get { __data["type"] }
      set { __data["type"] = newValue }
    }
  }

}