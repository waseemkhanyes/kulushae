// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

protocol GQLK_SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == GQLK.SchemaMetadata {}

protocol GQLK_InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == GQLK.SchemaMetadata {}

protocol GQLK_MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == GQLK.SchemaMetadata {}

protocol GQLK_MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == GQLK.SchemaMetadata {}

extension GQLK {
  typealias SelectionSet = GQLK_SelectionSet

  typealias InlineFragment = GQLK_InlineFragment

  typealias MutableSelectionSet = GQLK_MutableSelectionSet

  typealias MutableInlineFragment = GQLK_MutableInlineFragment

  enum SchemaMetadata: ApolloAPI.SchemaMetadata {
    static let configuration: any ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

    static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
      switch typename {
      case "Ads": return GQLK.Objects.Ads
      case "Amenity": return GQLK.Objects.Amenity
      case "Category": return GQLK.Objects.Category
      case "Chat": return GQLK.Objects.Chat
      case "Extra": return GQLK.Objects.Extra
      case "Favourite": return GQLK.Objects.Favourite
      case "Form": return GQLK.Objects.Form
      case "Image": return GQLK.Objects.Image
      case "Item": return GQLK.Objects.Item
      case "MakesResponse": return GQLK.Objects.MakesResponse
      case "Message": return GQLK.Objects.Message
      case "Motor": return GQLK.Objects.Motor
      case "MotorMake": return GQLK.Objects.MotorMake
      case "MotorModel": return GQLK.Objects.MotorModel
      case "MotorUser": return GQLK.Objects.MotorUser
      case "MotorsResponse": return GQLK.Objects.MotorsResponse
      case "Mutation": return GQLK.Objects.Mutation
      case "MutationResponse": return GQLK.Objects.MutationResponse
      case "Payment": return GQLK.Objects.Payment
      case "PropertiesResponse": return GQLK.Objects.PropertiesResponse
      case "Property": return GQLK.Objects.Property
      case "PropertyUser": return GQLK.Objects.PropertyUser
      case "Query": return GQLK.Objects.Query
      case "Response": return GQLK.Objects.Response
      case "SearchResponse": return GQLK.Objects.SearchResponse
      case "SocialMedia": return GQLK.Objects.SocialMedia
      case "UpdateResponse": return GQLK.Objects.UpdateResponse
      case "User": return GQLK.Objects.User
      case "UserAds": return GQLK.Objects.UserAds
      case "UserFavourites": return GQLK.Objects.UserFavourites
      case "UserVerficationResponse": return GQLK.Objects.UserVerficationResponse
      default: return nil
      }
    }
  }

  enum Objects {}
  enum Interfaces {}
  enum Unions {}

}