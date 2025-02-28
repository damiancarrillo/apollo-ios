// @generated
// This file was automatically generated and should not be edited.

@_exported import Apollo

public struct DogFragment: MyCustomProject.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString { """
    fragment DogFragment on Dog {
      __typename
      species
    }
    """ }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: Apollo.ParentType { MyCustomProject.Objects.Dog }
  public static var __selections: [Apollo.Selection] { [
    .field("__typename", String.self),
    .field("species", String.self),
  ] }

  public var species: String { __data["species"] }
}
