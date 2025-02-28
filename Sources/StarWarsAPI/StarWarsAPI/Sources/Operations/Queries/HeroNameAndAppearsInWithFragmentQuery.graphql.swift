// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class HeroNameAndAppearsInWithFragmentQuery: GraphQLQuery {
  public static let operationName: String = "HeroNameAndAppearsInWithFragment"
  public static let document: ApolloAPI.DocumentType = .automaticallyPersisted(
    operationIdentifier: "0664fed3eb4f9fbdb44e8691d9e8fd11f2b3c097ba11327592054f602bd3ba1a",
    definition: .init(
      #"""
      query HeroNameAndAppearsInWithFragment($episode: Episode) {
        hero(episode: $episode) {
          __typename
          ...CharacterNameAndAppearsIn
        }
      }
      """#,
      fragments: [CharacterNameAndAppearsIn.self]
    ))

  public var episode: GraphQLNullable<GraphQLEnum<Episode>>

  public init(episode: GraphQLNullable<GraphQLEnum<Episode>>) {
    self.episode = episode
  }

  public var __variables: Variables? { ["episode": episode] }

  public struct Data: StarWarsAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { StarWarsAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("hero", Hero?.self, arguments: ["episode": .variable("episode")]),
    ] }

    public var hero: Hero? { __data["hero"] }

    public init(
      hero: Hero? = nil
    ) {
      self.init(_dataDict: DataDict(data: [
        "__typename": StarWarsAPI.Objects.Query.typename,
        "hero": hero._fieldData,
        "__fulfilled": Set([
          ObjectIdentifier(Self.self)
        ])
      ]))
    }

    /// Hero
    ///
    /// Parent Type: `Character`
    public struct Hero: StarWarsAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { StarWarsAPI.Interfaces.Character }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(CharacterNameAndAppearsIn.self),
      ] }

      /// The name of the character
      public var name: String { __data["name"] }
      /// The movies this character appears in
      public var appearsIn: [GraphQLEnum<StarWarsAPI.Episode>?] { __data["appearsIn"] }

      public struct Fragments: FragmentContainer {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public var characterNameAndAppearsIn: CharacterNameAndAppearsIn { _toFragment() }
      }

      public init(
        __typename: String,
        name: String,
        appearsIn: [GraphQLEnum<StarWarsAPI.Episode>?]
      ) {
        self.init(_dataDict: DataDict(data: [
          "__typename": __typename,
          "name": name,
          "appearsIn": appearsIn,
          "__fulfilled": Set([
            ObjectIdentifier(Self.self),
            ObjectIdentifier(CharacterNameAndAppearsIn.self)
          ])
        ]))
      }
    }
  }
}
