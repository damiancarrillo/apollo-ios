import OrderedCollections

struct LocalCacheMutationDefinitionTemplate: OperationTemplateRenderer {
  /// IR representation of source [GraphQL Operation](https://spec.graphql.org/draft/#sec-Language.Operations).
  let operation: IR.Operation

  let config: ApolloCodegen.ConfigurationContext

  let target: TemplateTarget = .operationFile

  var template: TemplateString {
    let accessControl = embeddedAccessControlModifier(target: target)

    return TemplateString(
    """
    \(accessControl)\
    class \(operation.definition.nameWithSuffix.firstUppercased): LocalCacheMutation {
      \(accessControl)\
    static let operationType: GraphQLOperationType = .\(operation.definition.operationType.rawValue)

      \(section: VariableProperties(operation.definition.variables))

      \(Initializer(operation.definition.variables))

      \(section: VariableAccessors(operation.definition.variables, graphQLOperation: false))

      \(SelectionSetTemplate(
          mutable: true,
          generateInitializers: config.options.shouldGenerateSelectionSetInitializers(for: operation),
          config: config,
          accessControlRenderer: { embeddedAccessControlModifier(target: target) }()
      ).render(for: operation))
    }
    
    """)
  }

}
