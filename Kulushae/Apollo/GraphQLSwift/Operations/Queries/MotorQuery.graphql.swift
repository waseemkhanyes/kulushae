// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension GQLK {
  class MotorQuery: GraphQLQuery {
    static let operationName: String = "Motor"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query Motor($motorId: Int) { motor(id: $motorId) { __typename id country emirates make make_id model model_id trim specs year kilometers insured_in_uae price contact_info title desc tour_url fuel_type exterior_color interior_color warranty doors no_of_cylinders transmission_type body_type seating_capacity horsepwer engine_capacity user_id { __typename id image first_name last_name email phone member_since total_listings } steering_side category_id seller type extras { __typename id title } images { __typename id image } is_featured is_favorite is_active is_published is_new } }"#
      ))

    public var motorId: GraphQLNullable<Int>

    public init(motorId: GraphQLNullable<Int>) {
      self.motorId = motorId
    }

    public var __variables: Variables? { ["motorId": motorId] }

    struct Data: GQLK.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("motor", Motor?.self, arguments: ["id": .variable("motorId")]),
      ] }

      var motor: Motor? { __data["motor"] }

      /// Motor
      ///
      /// Parent Type: `Motor`
      struct Motor: GQLK.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Motor }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", Int.self),
          .field("country", String?.self),
          .field("emirates", String?.self),
          .field("make", String?.self),
          .field("make_id", Int?.self),
          .field("model", String?.self),
          .field("model_id", Int?.self),
          .field("trim", String?.self),
          .field("specs", String?.self),
          .field("year", String?.self),
          .field("kilometers", String?.self),
          .field("insured_in_uae", Bool?.self),
          .field("price", Double?.self),
          .field("contact_info", String?.self),
          .field("title", String?.self),
          .field("desc", String?.self),
          .field("tour_url", String?.self),
          .field("fuel_type", String?.self),
          .field("exterior_color", String?.self),
          .field("interior_color", String?.self),
          .field("warranty", String?.self),
          .field("doors", String?.self),
          .field("no_of_cylinders", String?.self),
          .field("transmission_type", String?.self),
          .field("body_type", String?.self),
          .field("seating_capacity", String?.self),
          .field("horsepwer", String?.self),
          .field("engine_capacity", String?.self),
          .field("user_id", User_id?.self),
          .field("steering_side", String?.self),
          .field("category_id", Int?.self),
          .field("seller", String?.self),
          .field("type", String?.self),
          .field("extras", [Extra?]?.self),
          .field("images", [Image?]?.self),
          .field("is_featured", Bool?.self),
          .field("is_favorite", Bool?.self),
          .field("is_active", Bool?.self),
          .field("is_published", Bool?.self),
          .field("is_new", Bool?.self),
        ] }

        var id: Int { __data["id"] }
        var country: String? { __data["country"] }
        var emirates: String? { __data["emirates"] }
        var make: String? { __data["make"] }
        var make_id: Int? { __data["make_id"] }
        var model: String? { __data["model"] }
        var model_id: Int? { __data["model_id"] }
        var trim: String? { __data["trim"] }
        var specs: String? { __data["specs"] }
        var year: String? { __data["year"] }
        var kilometers: String? { __data["kilometers"] }
        var insured_in_uae: Bool? { __data["insured_in_uae"] }
        var price: Double? { __data["price"] }
        var contact_info: String? { __data["contact_info"] }
        var title: String? { __data["title"] }
        var desc: String? { __data["desc"] }
        var tour_url: String? { __data["tour_url"] }
        var fuel_type: String? { __data["fuel_type"] }
        var exterior_color: String? { __data["exterior_color"] }
        var interior_color: String? { __data["interior_color"] }
        var warranty: String? { __data["warranty"] }
        var doors: String? { __data["doors"] }
        var no_of_cylinders: String? { __data["no_of_cylinders"] }
        var transmission_type: String? { __data["transmission_type"] }
        var body_type: String? { __data["body_type"] }
        var seating_capacity: String? { __data["seating_capacity"] }
        var horsepwer: String? { __data["horsepwer"] }
        var engine_capacity: String? { __data["engine_capacity"] }
        var user_id: User_id? { __data["user_id"] }
        var steering_side: String? { __data["steering_side"] }
        var category_id: Int? { __data["category_id"] }
        var seller: String? { __data["seller"] }
        var type: String? { __data["type"] }
        var extras: [Extra?]? { __data["extras"] }
        var images: [Image?]? { __data["images"] }
        var is_featured: Bool? { __data["is_featured"] }
        var is_favorite: Bool? { __data["is_favorite"] }
        var is_active: Bool? { __data["is_active"] }
        var is_published: Bool? { __data["is_published"] }
        var is_new: Bool? { __data["is_new"] }

        /// Motor.User_id
        ///
        /// Parent Type: `MotorUser`
        struct User_id: GQLK.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.MotorUser }
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

        /// Motor.Extra
        ///
        /// Parent Type: `Extra`
        struct Extra: GQLK.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { GQLK.Objects.Extra }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", GQLK.ID?.self),
            .field("title", String?.self),
          ] }

          var id: GQLK.ID? { __data["id"] }
          var title: String? { __data["title"] }
        }

        /// Motor.Image
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