// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension GQLK {
  class AmenitiesQuery: GraphQLQuery {
    static let operationName: String = "Amenities"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query Amenities { amenities { __typename id title } }"#
      ))

    public init() {}

    struct Data: GQLK.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("amenities", [Amenity?]?.self),
      ] }

      var amenities: [Amenity?]? { __data["amenities"] }

      /// Amenity
      ///
      /// Parent Type: `Amenity`
      struct Amenity: GQLK.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Amenity }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", GQLK.ID?.self),
          .field("title", String?.self),
        ] }

        var id: GQLK.ID? { __data["id"] }
        var title: String? { __data["title"] }
      }
    }
  }

}