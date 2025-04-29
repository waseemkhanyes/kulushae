// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension GQLK {
  class PropertyQuery: GraphQLQuery {
    static let operationName: String = "Property"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query Property($propertyId: Int) { property(id: $propertyId) { __typename id country emirates title contact_number price description socialmedia { __typename id type value } size total_closing_fee bedrooms bathrooms developer ready_by annual_community_fee furnished reference_number buyer_transfer_fee seller_transfer_fee maintenance_fee occupancy_status amenities { __typename id title } posted_by user_id { __typename id image first_name last_name email phone member_since total_listings } neighbourhood location category_id images { __typename id image } is_featured is_favorite type deposit } }"#
      ))

    public var propertyId: GraphQLNullable<Int>

    public init(propertyId: GraphQLNullable<Int>) {
      self.propertyId = propertyId
    }

    public var __variables: Variables? { ["propertyId": propertyId] }

    struct Data: GQLK.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("property", Property?.self, arguments: ["id": .variable("propertyId")]),
      ] }

      var property: Property? { __data["property"] }

      /// Property
      ///
      /// Parent Type: `Property`
      struct Property: GQLK.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Property }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", Int.self),
          .field("country", String?.self),
          .field("emirates", String?.self),
          .field("title", String?.self),
          .field("contact_number", String.self),
          .field("price", Double?.self),
          .field("description", String.self),
          .field("socialmedia", [Socialmedium?]?.self),
          .field("size", String?.self),
          .field("total_closing_fee", String?.self),
          .field("bedrooms", String?.self),
          .field("bathrooms", String?.self),
          .field("developer", String?.self),
          .field("ready_by", String?.self),
          .field("annual_community_fee", Double?.self),
          .field("furnished", Bool?.self),
          .field("reference_number", String?.self),
          .field("buyer_transfer_fee", String?.self),
          .field("seller_transfer_fee", String?.self),
          .field("maintenance_fee", String?.self),
          .field("occupancy_status", String?.self),
          .field("amenities", [Amenity?]?.self),
          .field("posted_by", String?.self),
          .field("user_id", User_id?.self),
          .field("neighbourhood", String?.self),
          .field("location", String.self),
          .field("category_id", Int.self),
          .field("images", [Image?]?.self),
          .field("is_featured", Bool?.self),
          .field("is_favorite", Bool?.self),
          .field("type", String?.self),
          .field("deposit", Int?.self),
        ] }

        var id: Int { __data["id"] }
        var country: String? { __data["country"] }
        var emirates: String? { __data["emirates"] }
        var title: String? { __data["title"] }
        var contact_number: String { __data["contact_number"] }
        var price: Double? { __data["price"] }
        var description: String { __data["description"] }
        var socialmedia: [Socialmedium?]? { __data["socialmedia"] }
        var size: String? { __data["size"] }
        var total_closing_fee: String? { __data["total_closing_fee"] }
        var bedrooms: String? { __data["bedrooms"] }
        var bathrooms: String? { __data["bathrooms"] }
        var developer: String? { __data["developer"] }
        var ready_by: String? { __data["ready_by"] }
        var annual_community_fee: Double? { __data["annual_community_fee"] }
        var furnished: Bool? { __data["furnished"] }
        var reference_number: String? { __data["reference_number"] }
        var buyer_transfer_fee: String? { __data["buyer_transfer_fee"] }
        var seller_transfer_fee: String? { __data["seller_transfer_fee"] }
        var maintenance_fee: String? { __data["maintenance_fee"] }
        var occupancy_status: String? { __data["occupancy_status"] }
        var amenities: [Amenity?]? { __data["amenities"] }
        var posted_by: String? { __data["posted_by"] }
        var user_id: User_id? { __data["user_id"] }
        var neighbourhood: String? { __data["neighbourhood"] }
        var location: String { __data["location"] }
        var category_id: Int { __data["category_id"] }
        var images: [Image?]? { __data["images"] }
        var is_featured: Bool? { __data["is_featured"] }
        var is_favorite: Bool? { __data["is_favorite"] }
        var type: String? { __data["type"] }
        var deposit: Int? { __data["deposit"] }

        /// Property.Socialmedium
        ///
        /// Parent Type: `SocialMedia`
        struct Socialmedium: GQLK.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.SocialMedia }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", GQLK.ID?.self),
            .field("type", String?.self),
            .field("value", String?.self),
          ] }

          var id: GQLK.ID? { __data["id"] }
          var type: String? { __data["type"] }
          var value: String? { __data["value"] }
        }

        /// Property.Amenity
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

        /// Property.User_id
        ///
        /// Parent Type: `PropertyUser`
        struct User_id: GQLK.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.PropertyUser }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", GQLK.ID.self),
            .field("image", String?.self),
            .field("first_name", String?.self),
            .field("last_name", String?.self),
            .field("email", String?.self),
            .field("phone", String?.self),
            .field("member_since", String?.self),
            .field("total_listings", Int?.self),
          ] }

          var id: GQLK.ID { __data["id"] }
          var image: String? { __data["image"] }
          var first_name: String? { __data["first_name"] }
          var last_name: String? { __data["last_name"] }
          var email: String? { __data["email"] }
          var phone: String? { __data["phone"] }
          var member_since: String? { __data["member_since"] }
          var total_listings: Int? { __data["total_listings"] }
        }

        /// Property.Image
        ///
        /// Parent Type: `Image`
        struct Image: GQLK.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Image }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", GQLK.ID?.self),
            .field("image", String?.self),
          ] }

          var id: GQLK.ID? { __data["id"] }
          var image: String? { __data["image"] }
        }
      }
    }
  }

}