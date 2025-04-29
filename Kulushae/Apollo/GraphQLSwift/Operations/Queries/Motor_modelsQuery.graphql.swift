// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension GQLK {
  class Motor_modelsQuery: GraphQLQuery {
    static let operationName: String = "Motor_models"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query Motor_models($makeId: Int) { motor_models(make_id: $makeId) { __typename id image title motor_make_id } }"#
      ))

    public var makeId: GraphQLNullable<Int>

    public init(makeId: GraphQLNullable<Int>) {
      self.makeId = makeId
    }

    public var __variables: Variables? { ["makeId": makeId] }

    struct Data: GQLK.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("motor_models", [Motor_model?]?.self, arguments: ["make_id": .variable("makeId")]),
      ] }

      var motor_models: [Motor_model?]? { __data["motor_models"] }

      /// Motor_model
      ///
      /// Parent Type: `MotorModel`
      struct Motor_model: GQLK.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.MotorModel }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", GQLK.ID?.self),
          .field("image", String?.self),
          .field("title", String?.self),
          .field("motor_make_id", Int?.self),
        ] }

        var id: GQLK.ID? { __data["id"] }
        var image: String? { __data["image"] }
        var title: String? { __data["title"] }
        var motor_make_id: Int? { __data["motor_make_id"] }
      }
    }
  }

}