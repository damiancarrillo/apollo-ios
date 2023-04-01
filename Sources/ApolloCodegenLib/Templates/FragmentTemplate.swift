import Foundation

/// Provides the format to convert a [GraphQL Fragment](https://spec.graphql.org/draft/#sec-Language.Fragments)
/// into Swift code.
struct FragmentTemplate: TemplateRenderer {
  /// IR representation of source [GraphQL Fragment](https://spec.graphql.org/draft/#sec-Language.Fragments).
  let fragment: IR.NamedFragment

  let config: ApolloCodegen.ConfigurationContext

  let target: TemplateTarget = .operationFile

  var template: TemplateString {
    let accessControl = embeddedAccessControlModifier(target: target)

    return TemplateString(
    """
    \(accessControl)\
    struct \(fragment.name.firstUppercased): \(config.schemaNamespace.firstUppercased)\
    .\(if: isMutable, "Mutable")SelectionSet, Fragment {
      \(accessControl)static var fragmentDefinition: StaticString { ""\"
        \(fragment.definition.source)
        ""\" }

      \(SelectionSetTemplate(
        mutable: isMutable,
        generateInitializers: config.options.shouldGenerateSelectionSetInitializers(for: fragment),
        config: config,
        accessControlRenderer: { embeddedAccessControlModifier(target: target) }()
      ).BodyTemplate(fragment.rootField.selectionSet))
    }

    """)
  }

  private var isMutable: Bool {
    fragment.definition.isLocalCacheMutation
  }
}
